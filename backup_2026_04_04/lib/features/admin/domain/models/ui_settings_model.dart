class PageSpacing {
  final double mobile;
  final double tablet;
  final double desktop;

  const PageSpacing({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  factory PageSpacing.fromJson(Map<String, dynamic> json) {
    return PageSpacing(
      mobile: (json['mobile'] as num).toDouble(),
      tablet: (json['tablet'] as num).toDouble(),
      desktop: (json['desktop'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'tablet': tablet,
      'desktop': desktop,
    };
  }

  factory PageSpacing.defaultValue() => const PageSpacing(
        mobile: 60,
        tablet: 80,
        desktop: 100,
      );

  PageSpacing copyWith({
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return PageSpacing(
      mobile: mobile ?? this.mobile,
      tablet: tablet ?? this.tablet,
      desktop: desktop ?? this.desktop,
    );
  }
}

class UiSettingsModel {
  final String id;
  final PageSpacing resumeSpacing;
  final PageSpacing portfolioSpacing;
  final PageSpacing documentsSpacing;
  final DateTime updatedAt;

  const UiSettingsModel({
    required this.id,
    required this.resumeSpacing,
    required this.portfolioSpacing,
    required this.documentsSpacing,
    required this.updatedAt,
  });

  factory UiSettingsModel.fromJson(Map<String, dynamic> json) {
    return UiSettingsModel(
      id: json['id'] as String,
      resumeSpacing: PageSpacing.fromJson(json['resumeSpacing'] as Map<String, dynamic>),
      portfolioSpacing: PageSpacing.fromJson(json['portfolioSpacing'] as Map<String, dynamic>),
      documentsSpacing: PageSpacing.fromJson(json['documentsSpacing'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resumeSpacing': resumeSpacing.toJson(),
      'portfolioSpacing': portfolioSpacing.toJson(),
      'documentsSpacing': documentsSpacing.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UiSettingsModel.defaultSettings() => UiSettingsModel(
        id: 'ui_settings',
        resumeSpacing: PageSpacing.defaultValue(),
        portfolioSpacing: PageSpacing.defaultValue(),
        documentsSpacing: PageSpacing.defaultValue(),
        updatedAt: DateTime.now(),
      );

  UiSettingsModel copyWith({
    String? id,
    PageSpacing? resumeSpacing,
    PageSpacing? portfolioSpacing,
    PageSpacing? documentsSpacing,
    DateTime? updatedAt,
  }) {
    return UiSettingsModel(
      id: id ?? this.id,
      resumeSpacing: resumeSpacing ?? this.resumeSpacing,
      portfolioSpacing: portfolioSpacing ?? this.portfolioSpacing,
      documentsSpacing: documentsSpacing ?? this.documentsSpacing,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
