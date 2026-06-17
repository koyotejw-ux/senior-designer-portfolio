class SkillModel {
  final String id;
  final String
  title; // Was 'category' - mapped to 'title' in UI, 'name' in JSON
  final List<String> skills; // List of skills
  final int order;
  final String iconName; // To map to IconData if needed

  SkillModel({
    required this.id,
    required this.title,
    required this.skills,
    required this.order,
    this.iconName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'skills': skills,
      'order': order,
      'iconName': iconName,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    // Handle legacy/alternate JSON structure
    // If 'name' exists, use it as title. If 'skills' is missing, maybe use 'description' or wrap 'name'
    return SkillModel(
      id: id,
      title: map['title'] ?? map['name'] ?? map['category'] ?? '',
      skills: map['skills'] != null
          ? List<String>.from(map['skills'])
          : (map['description'] != null ? [map['description']] : []),
      order: map['order'] ?? 0,
      iconName: map['iconName'] ?? '',
    );
  }
}
