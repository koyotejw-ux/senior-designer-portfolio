class ExperienceModel {
  final String id;
  final String company;
  final String role;
  final String period;
  final List<String> responsibilities;
  final List<String> achievements;
  final List<String> tools;
  final List<String> environment;
  final String reasonForLeaving;
  final int order;

  ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.period,
    required this.responsibilities,
    required this.achievements,
    required this.tools,
    required this.environment,
    required this.reasonForLeaving,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'role': role,
      'period': period,
      'responsibilities': responsibilities,
      'achievements': achievements,
      'tools': tools,
      'environment': environment,
      'reasonForLeaving': reasonForLeaving,
      'order': order,
    };
  }

  factory ExperienceModel.fromMap(Map<String, dynamic> map, String id) {
    return ExperienceModel(
      id: id,
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      period: map['period'] ?? '',
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
      achievements: List<String>.from(map['achievements'] ?? []),
      tools: List<String>.from(map['tools'] ?? []),
      environment: List<String>.from(map['environment'] ?? []),
      reasonForLeaving: map['reasonForLeaving'] ?? '',
      order: map['order'] ?? 0,
    );
  }
}
