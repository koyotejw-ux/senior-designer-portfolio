class ExperienceModel {
  final String id;
  final String company;
  final String role; // Mapped from 'position' in JSON if needed, or 'role'
  final String period;
  final String description; // Added for simple description support
  final List<String> responsibilities;
  final List<String> achievements;
  final List<String> tools;
  final List<String> environment;
  final String reasonForLeaving;
  final int order;
  final List<String> tags; // Added for tags support in UI

  ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.period,
    this.description = '',
    this.responsibilities = const [],
    this.achievements = const [],
    this.tools = const [],
    this.environment = const [],
    this.reasonForLeaving = '',
    required this.order,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role, // JSON often uses 'position' or 'role'
      'period': period,
      'description': description,
      'responsibilities': responsibilities,
      'achievements': achievements,
      'tools': tools,
      'environment': environment,
      'reasonForLeaving': reasonForLeaving,
      'order': order,
      'tags': tags,
    };
  }

  factory ExperienceModel.fromMap(Map<String, dynamic> map, String id) {
    return ExperienceModel(
      id: id,
      company: map['company'] ?? '',
      role: map['role'] ?? map['position'] ?? '', // Fallback for 'position'
      period: map['period'] ?? '',
      description: map['description'] ?? '',
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
      achievements: List<String>.from(map['achievements'] ?? []),
      tools: List<String>.from(map['tools'] ?? []),
      environment: List<String>.from(map['environment'] ?? []),
      reasonForLeaving: map['reasonForLeaving'] ?? '',
      order: map['order'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
