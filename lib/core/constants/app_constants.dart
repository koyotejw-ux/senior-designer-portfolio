class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = '정재웅';
  static const String appTitle = 'Jaewoong Jung - Senior Product Designer';
  static const String designerName = '정재웅';
  static const String designerNameEn = 'Jaewoong Jung';
  static const String tagline = 'Design System Architect | Scaling Enterprise Product Impact Through Data & AI';

  // Contact Info
  static const String email = 'coyotejw@naver.com';
  static const String phone = '010-4375-3599';

  // Experience
  static const int yearsOfExperience = 19;
  static const String role = 'Senior Product Designer';
  static const String subtitle = 'UX/UI Designer';

  // Social Links (to be added)
  static const String linkedinUrl = '';
  static const String githubUrl = '';
  static const String behanceUrl = '';
  static const String dribbbleUrl = '';

  // Real career data
  static const List<Map<String, String>> companies = [
    {'name': 'ING People', 'name_kr': '아이엔지피플', 'period': '2025.01-2025.06', 'role': 'UX Manager'},
    {'name': 'Hyundai HT', 'name_kr': '현대에이치티', 'period': '2018.05-2024.03', 'role': 'Senior Researcher'},
    {'name': 'BluestoneSoft', 'name_kr': '블루스톤소프트', 'period': '2016.05-2017.06', 'role': 'Lead Researcher'},
    {'name': 'NEXON Korea', 'name_kr': '넥슨코리아', 'period': '2010.10-2015.12', 'role': 'Manager'},
    {'name': 'YNK Korea', 'name_kr': 'YNK코리아', 'period': '2008.07-2010.10', 'role': 'Assistant Manager'},
  ];

  // Real projects from portfolio
  static const List<Map<String, String>> projects = [
    {'title': 'AIA+ SENIOR MODE', 'company': 'ING People', 'year': '2025', 'category': 'Mobile App'},
    {'title': 'WALLPAD', 'company': 'Hyundai HT', 'year': '2021-2023', 'category': 'IoT Device'},
    {'title': 'HT HOME 2.0', 'company': 'Hyundai HT', 'year': '2021-2023', 'category': 'Mobile App'},
    {'title': 'SOULARK', 'company': 'BluestoneSoft', 'year': '2016-2017', 'category': 'Mobile Game'},
    {'title': 'CLOSERS', 'company': 'NEXON Korea', 'year': '2014', 'category': 'Website'},
  ];

  // Layout
  static const double maxContentWidth = 1440;
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
  static const double spacingXXXL = 64;

  // Border Radius
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 24;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // PDF Settings
  static const String pdfAuthor = 'Jaewoong Jung';
  static const String pdfSubject = 'Portfolio & Professional Documents';

  // Firebase Collections
  static const String projectsCollection = 'projects';
  static const String resumeCollection = 'resumes';
  static const String coverLetterCollection = 'cover_letters';
  static const String careerStatementCollection = 'career_statements';
  static const String versionsCollection = 'versions';

  // Version Tags
  static const List<String> versionTags = [
    'Tech Company',
    'Startup',
    'Enterprise',
    'Consulting',
    'Finance',
    'Healthcare',
    'Final',
  ];

  // API Configuration
  static const String serverUrl = 'http://localhost:8080';  // Server URL
  static const String apiBaseUrl = '$serverUrl/api';
  static const String uploadEndpoint = '$serverUrl/upload';
  static const String imagesPath = '$serverUrl/images';  // Full URL for images

  // Image Upload Settings
  static const int maxImageSizeBytes = 50 * 1024 * 1024;  // 50MB max
  static const int thumbnailMaxWidth = 800;  // Thumbnail width for preview
  static const int thumbnailMaxHeight = 600;  // Thumbnail height for preview
  static const int thumbnailQuality = 85;  // JPEG quality for thumbnails
}
