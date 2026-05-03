enum AssistantMode {
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
    description: 'Infrastructure, CI/CD, and deployment strategies.',
  ),
  dataScience(
    name: 'Data Science',
    description: 'Analytics, ML approaches, and statistical methods.',
  );

  final String name;
  final String description;

  const AssistantMode({
    required this.name,
    required this.description,
  });
}
