import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    
    setupStealthChannel(controller: flutterViewController)

    super.awakeFromNib()
  }
  
  private func setupStealthChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(name: "com.ghost.assist/stealth",
                                      binaryMessenger: controller.engine.binaryMessenger)
    
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "setStealthMode":
        if let args = call.arguments as? [String: Any],
           let enabled = args["enabled"] as? Bool {
          self.sharingType = enabled ? .none : .readWrite
          result(true)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected boolean 'enabled'", details: nil))
        }
      case "isStealthEnabled":
        result(self.sharingType == .none)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    // Default to stealth mode enabled
    self.sharingType = .none
  }
}
