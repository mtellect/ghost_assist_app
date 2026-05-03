abstract class EnvironmentKeys {
  static const prod = 'prod';
  static const staging = 'staging';
}

sealed class ApiEnvironmentEnum {
  const ApiEnvironmentEnum(this.key);
  final String key;
}

enum AppFlavor {
  ghostAssist, // Adapted from alongCustomer/Driver
  ;

  factory AppFlavor.fromKey(String? key) {
    key = key?.toLowerCase();
    return switch (key) {
      _ => AppFlavor.ghostAssist,
    };
  }

  bool get isGhostAssist => this == AppFlavor.ghostAssist;
}

enum GhostAssistEnvironmentEnum implements ApiEnvironmentEnum {
  prod(EnvironmentKeys.prod),
  staging(EnvironmentKeys.staging)
  ;

  const GhostAssistEnvironmentEnum(this.key);
  factory GhostAssistEnvironmentEnum.fromKey(String? key) {
    return switch (key?.contains('prod')) {
      true => GhostAssistEnvironmentEnum.prod,
      _ => GhostAssistEnvironmentEnum.staging,
    };
  }

  @override
  final String key;
}

// Helper method to get any Environment from key
ApiEnvironmentEnum getEnvironmentFromKey(String? key) {
  return switch (AppFlavor.fromKey(key)) {
    AppFlavor.ghostAssist => GhostAssistEnvironmentEnum.fromKey(key),
  };
}
