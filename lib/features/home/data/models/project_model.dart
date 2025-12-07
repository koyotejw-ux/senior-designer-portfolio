import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String company;
  final String year;
  final String category;
  final String description;
  final List<String> tags;
  final String? imageUrl;
  final List<Color> gradientColors;

  ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.company,
    required this.year,
    required this.category,
    required this.description,
    required this.tags,
    this.imageUrl,
    required this.gradientColors,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    // Helper to parse colors from hex strings or use defaults
    List<Color> parseColors(dynamic colors) {
      if (colors is List) {
        return colors.map((c) {
          if (c is int) return Color(c);
          if (c is String) {
            return Color(int.parse(c.replaceAll('#', '0xFF')));
          }
          return AppColors.primaryBlue;
        }).toList();
      }
      return [AppColors.primaryBlue, AppColors.accentCyan];
    }

    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      company: map['company'] ?? '',
      year: map['year'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
      gradientColors: parseColors(map['gradientColors']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'company': company,
      'year': year,
      'category': category,
      'description': description,
      'tags': tags,
      'imageUrl': imageUrl,
      'gradientColors': gradientColors.map((c) => c.value).toList(),
    };
  }
}
