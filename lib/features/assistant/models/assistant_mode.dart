enum AssistantMode {
  flutter(
    name: 'Flutter',
    description: 'Expert Dart/Flutter development, state management, and widgets.',
  ),
  ios(
    name: 'iOS',
    description: 'Swift, SwiftUI, and native Apple platform engineering.',
  ),
  android(
    name: 'Android',
    description: 'Kotlin, Jetpack Compose, and native Android architecture.',
  ),
  springboot(
    name: 'Spring Boot',
    description: 'Java/Spring Boot microservices and enterprise architecture.',
  ),
  dsa(
    name: 'DSA',
    description: 'Data Structures & Algorithms solutions with complexity analysis.',
  ),
  systemDesign(
    name: 'System Design',
    description: 'Architecture patterns and scalability approaches.',
  ),
  programming(
    name: 'Programming',
    description: 'Multi-language coding assistance and best practices.',
  ),
  behavioral(
    name: 'Behavioral',
    description: 'STAR method responses and professional scenarios.',
  ),
  sales(
    name: 'Sales',
    description: 'Frameworks, objection handling, and closing techniques.',
  ),
  negotiation(
    name: 'Negotiation',
    description: 'Strategic approaches and persuasion tactics.',
  ),
  presentation(
    name: 'Presentation',
    description: 'Structure, delivery tips, and visual design.',
  ),
  devOps(
    name: 'DevOps',
    description: 'CI/CD, Cloud, and infrastructure automation.',
  ),
  dataScience(
    name: 'Data Science',
    description: 'Machine learning, statistics, and data analysis.',
  );

  final String name;
  final String description;

  const AssistantMode({
    required this.name,
    required this.description,
  });
}
