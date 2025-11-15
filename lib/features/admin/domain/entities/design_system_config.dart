import 'package:flutter/material.dart';

/// Design System Configuration Entity
/// Allows admin to customize colors, typography, spacing, etc.
class DesignSystemConfig {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  // Colors
  final String primaryColor;
  final String secondaryColor;
  final String tertiaryColor;
  final String backgroundColor;

  // Typography
  final String displayFontFamily;
  final String bodyFontFamily;
  final Map<String, double> fontSizes;

  // Spacing
  final Map<String, double> spacing;

  // Border Radius
  final Map<String, double> borderRadius;

  // Custom Properties
  final Map<String, dynamic> customProperties;

  DesignSystemConfig({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.backgroundColor,
    required this.displayFontFamily,
    required this.bodyFontFamily,
    required this.fontSizes,
    required this.spacing,
    required this.borderRadius,
    this.customProperties = const {},
  });

  // Convert hex string to Color
  Color getPrimaryColor() => Color(int.parse(primaryColor.replaceFirst('#', '0xFF')));
  Color getSecondaryColor() => Color(int.parse(secondaryColor.replaceFirst('#', '0xFF')));
  Color getTertiaryColor() => Color(int.parse(tertiaryColor.replaceFirst('#', '0xFF')));
  Color getBackgroundColor() => Color(int.parse(backgroundColor.replaceFirst('#', '0xFF')));

  DesignSystemConfig copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? primaryColor,
    String? secondaryColor,
    String? tertiaryColor,
    String? backgroundColor,
    String? displayFontFamily,
    String? bodyFontFamily,
    Map<String, double>? fontSizes,
    Map<String, double>? spacing,
    Map<String, double>? borderRadius,
    Map<String, dynamic>? customProperties,
  }) {
    return DesignSystemConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      displayFontFamily: displayFontFamily ?? this.displayFontFamily,
      bodyFontFamily: bodyFontFamily ?? this.bodyFontFamily,
      fontSizes: fontSizes ?? this.fontSizes,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'tertiaryColor': tertiaryColor,
      'backgroundColor': backgroundColor,
      'displayFontFamily': displayFontFamily,
      'bodyFontFamily': bodyFontFamily,
      'fontSizes': fontSizes,
      'spacing': spacing,
      'borderRadius': borderRadius,
      'customProperties': customProperties,
    };
  }

  factory DesignSystemConfig.fromJson(Map<String, dynamic> json) {
    return DesignSystemConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      tertiaryColor: json['tertiaryColor'] as String,
      backgroundColor: json['backgroundColor'] as String,
      displayFontFamily: json['displayFontFamily'] as String,
      bodyFontFamily: json['bodyFontFamily'] as String,
      fontSizes: Map<String, double>.from(json['fontSizes'] as Map),
      spacing: Map<String, double>.from(json['spacing'] as Map),
      borderRadius: Map<String, double>.from(json['borderRadius'] as Map),
      customProperties: json['customProperties'] as Map<String, dynamic>? ?? {},
    );
  }

  // Factory for default design system (current brand)
  factory DesignSystemConfig.defaultConfig() {
    return DesignSystemConfig(
      id: 'default',
      name: 'Jaewoong Jung Brand',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
      primaryColor: '#0068B3',
      secondaryColor: '#009DDC',
      tertiaryColor: '#C1D72E',
      backgroundColor: '#0A0E1A',
      displayFontFamily: 'Space Grotesk',
      bodyFontFamily: 'Noto Sans KR',
      fontSizes: {
        'display1': 96.0,
        'display2': 72.0,
        'display3': 56.0,
        'h1': 48.0,
        'h2': 40.0,
        'h3': 32.0,
        'h4': 24.0,
        'h5': 20.0,
        'h6': 18.0,
        'bodyLarge': 18.0,
        'bodyMedium': 16.0,
        'bodySmall': 14.0,
      },
      spacing: {
        'xs': 4.0,
        's': 8.0,
        'm': 16.0,
        'l': 24.0,
        'xl': 32.0,
        'xxl': 48.0,
        'xxxl': 64.0,
      },
      borderRadius: {
        's': 8.0,
        'm': 12.0,
        'l': 16.0,
        'xl': 24.0,
      },
    );
  }
}
