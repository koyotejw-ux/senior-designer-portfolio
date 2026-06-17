class EducationModel {
  final String id;
  final String period;
  final String school;
  final String major;
  final String gpa;
  final int order;

  EducationModel({
    required this.id,
    required this.period,
    required this.school,
    required this.major,
    required this.gpa,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'period': period,
      'school': school,
      'major': major,
      'gpa': gpa,
      'order': order,
    };
  }

  factory EducationModel.fromMap(Map<String, dynamic> map, String id) {
    return EducationModel(
      id: id,
      period: map['period'] ?? '',
      school: map['school'] ?? '',
      major: map['major'] ?? '',
      gpa: map['gpa'] ?? '',
      order: map['order'] ?? 0,
    );
  }
}
