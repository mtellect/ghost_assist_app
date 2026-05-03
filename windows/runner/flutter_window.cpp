#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Setup Stealth Mode Channel
  stealth_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(), "com.ghost.assist/stealth",
      &flutter::StandardMethodCodec::GetInstance());

  stealth_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name().compare("setStealthMode") == 0) {
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          if (arguments) {
            auto enabled_it = arguments->find(flutter::EncodableValue("enabled"));
            if (enabled_it != arguments->end() && std::holds_alternative<bool>(enabled_it->second)) {
              bool enabled = std::get<bool>(enabled_it->second);
              HWND hwnd = GetNativeWindow();
              
              if (hwnd != NULL) {
                // WDA_EXCLUDEFROMCAPTURE (0x00000011) hides window from screen capture/sharing
                DWORD affinity = enabled ? 0x00000011 : 0x00000000;
                SetWindowDisplayAffinity(hwnd, affinity);
                
                // Force a redraw to ensure the affinity change is registered
                SetWindowPos(hwnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);
                result->Success(flutter::EncodableValue(true));
                return;
              }
            }
          }
          result->Error("INVALID_ARGUMENTS", "Expected boolean 'enabled'");
        } else if (call.method_name().compare("isStealthEnabled") == 0) {
          HWND hwnd = GetNativeWindow();
          if (hwnd != NULL) {
            DWORD affinity = 0;
            if (GetWindowDisplayAffinity(hwnd, &affinity)) {
              result->Success(flutter::EncodableValue(affinity != 0));
              return;
            }
          }
          result->Success(flutter::EncodableValue(false));
        } else {
          result->NotImplemented();
        }
      });

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
