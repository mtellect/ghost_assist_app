enum AssistantSkill {
  flutter,
  ios,
  android,
  springboot,
  dsa,
  systemDesign,
  programming,
  behavioral,
  devOps,
  dataScience,
  custom;

  String get displayName {
    switch (this) {
      case AssistantSkill.flutter:
        return 'Flutter';
      case AssistantSkill.ios:
        return 'iOS / Swift';
      case AssistantSkill.android:
        return 'Android / Kotlin';
      case AssistantSkill.springboot:
        return 'Spring Boot';
      case AssistantSkill.dsa:
        return 'Algorithms & DSA';
      case AssistantSkill.systemDesign:
        return 'System Design';
      case AssistantSkill.programming:
        return 'Programming';
      case AssistantSkill.behavioral:
        return 'Behavioral / Leadership';
      case AssistantSkill.devOps:
        return 'DevOps / Cloud';
      case AssistantSkill.dataScience:
        return 'Data Science';
      case AssistantSkill.custom:
        return 'Custom Expert';
    }
  }
}
