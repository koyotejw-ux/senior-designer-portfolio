class PortfolioModel {
  final String id;
  final String title;
  final String subtitle;
  final String company;
  final String year;
  final String category;
  final String description;
  final List<String> tags;
  final List<String> gradientColors; // Hex color codes
  final String role;
  final String duration;
  final String teamSize;
  final List<String> achievements;
  final List<String> technologies;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PortfolioModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.company,
    required this.year,
    required this.category,
    required this.description,
    required this.tags,
    required this.gradientColors,
    required this.role,
    required this.duration,
    required this.teamSize,
    required this.achievements,
    required this.technologies,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      company: json['company'] as String,
      year: json['year'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      gradientColors: (json['gradientColors'] as List<dynamic>).cast<String>(),
      role: json['role'] as String,
      duration: json['duration'] as String,
      teamSize: json['teamSize'] as String,
      achievements: (json['achievements'] as List<dynamic>).cast<String>(),
      technologies: (json['technologies'] as List<dynamic>).cast<String>(),
      order: json['order'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'company': company,
      'year': year,
      'category': category,
      'description': description,
      'tags': tags,
      'gradientColors': gradientColors,
      'role': role,
      'duration': duration,
      'teamSize': teamSize,
      'achievements': achievements,
      'technologies': technologies,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PortfolioModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? company,
    String? year,
    String? category,
    String? description,
    List<String>? tags,
    List<String>? gradientColors,
    String? role,
    String? duration,
    String? teamSize,
    List<String>? achievements,
    List<String>? technologies,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PortfolioModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      company: company ?? this.company,
      year: year ?? this.year,
      category: category ?? this.category,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      gradientColors: gradientColors ?? this.gradientColors,
      role: role ?? this.role,
      duration: duration ?? this.duration,
      teamSize: teamSize ?? this.teamSize,
      achievements: achievements ?? this.achievements,
      technologies: technologies ?? this.technologies,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum PortfolioCategory {
  all('All', '전체'),
  mobileApp('Mobile App', '모바일 앱'),
  iotDevice('IoT Device', 'IoT 기기'),
  webDesign('Web Design', '웹 디자인'),
  gameUi('Game UI', '게임 UI');

  final String value;
  final String displayName;

  const PortfolioCategory(this.value, this.displayName);

  static PortfolioCategory fromValue(String value) {
    return PortfolioCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => PortfolioCategory.all,
    );
  }
}
