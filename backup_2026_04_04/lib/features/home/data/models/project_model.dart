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
  final int order;

  // New fields for detailed portfolio
  final String? role;
  final String? duration;
  final String? teamSize;
  final List<String> mainScreenImages;
  final DesignSystemModel? designSystem;
  final bool isCorporate;

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
    this.order = 0,
    this.role,
    this.duration,
    this.teamSize,
    this.mainScreenImages = const [],
    this.designSystem,
    this.isCorporate = false,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
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
      order: map['order'] ?? 0,
      role: map['role'],
      duration: map['duration'],
      teamSize: map['teamSize'],
      mainScreenImages: List<String>.from(map['mainScreenImages'] ?? []),
      designSystem: map['designSystem'] != null
          ? DesignSystemModel.fromMap(map['designSystem'])
          : null,
      isCorporate: map['isCorporate'] ?? false,
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
      'gradientColors': gradientColors
          .map((c) => '0x${c.value.toRadixString(16).padLeft(8, '0')}')
          .toList(),
      'order': order,
      'role': role,
      'duration': duration,
      'teamSize': teamSize,
      'mainScreenImages': mainScreenImages,
      'designSystem': designSystem?.toMap(),
      'isCorporate': isCorporate,
    };
  }
}

class DesignSystemModel {
  final FoundationModel foundation;
  final AtomicModel atomic;

  DesignSystemModel({required this.foundation, required this.atomic});

  factory DesignSystemModel.fromMap(Map<String, dynamic> map) {
    return DesignSystemModel(
      foundation: FoundationModel.fromMap(map['foundation'] ?? {}),
      atomic: AtomicModel.fromMap(map['atomic'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {'foundation': foundation.toMap(), 'atomic': atomic.toMap()};
  }
}

class FoundationModel {
  final List<String> colors;
  final List<String> typography;
  final List<String> spacing;

  FoundationModel({
    this.colors = const [],
    this.typography = const [],
    this.spacing = const [],
  });

  factory FoundationModel.fromMap(Map<String, dynamic> map) {
    return FoundationModel(
      colors: List<String>.from(map['colors'] ?? []),
      typography: List<String>.from(map['typography'] ?? []),
      spacing: List<String>.from(map['spacing'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'colors': colors, 'typography': typography, 'spacing': spacing};
  }
}

class AtomicModel {
  final List<String> atoms;
  final List<String> molecules;
  final List<String> organisms;

  AtomicModel({
    this.atoms = const [],
    this.molecules = const [],
    this.organisms = const [],
  });

  factory AtomicModel.fromMap(Map<String, dynamic> map) {
    return AtomicModel(
      atoms: List<String>.from(map['atoms'] ?? []),
      molecules: List<String>.from(map['molecules'] ?? []),
      organisms: List<String>.from(map['organisms'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'atoms': atoms, 'molecules': molecules, 'organisms': organisms};
  }
}
