class SkillModel {
  final String id;
  final String category; // 'competency' or 'qualification'
  final String description;
  final int order;

  SkillModel({
    required this.id,
    required this.category,
    required this.description,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {'category': category, 'description': description, 'order': order};
  }

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    return SkillModel(
      id: id,
      category: map['category'] ?? 'competency',
      description: map['description'] ?? '',
      order: map['order'] ?? 0,
    );
  }
}
