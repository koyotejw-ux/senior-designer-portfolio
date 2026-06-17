class ResumeModel {
  final String id;
  final String? photoUrl;
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<Career> careers;
  final List<String> coreCompetencies;
  final List<Certification> certifications;
  final DateTime? lastUpdated;

  const ResumeModel({
    required this.id,
    this.photoUrl,
    required this.personalInfo,
    required this.education,
    required this.careers,
    required this.coreCompetencies,
    required this.certifications,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'photoUrl': photoUrl,
        'personalInfo': personalInfo.toJson(),
        'education': education.map((e) => e.toJson()).toList(),
        'careers': careers.map((c) => c.toJson()).toList(),
        'coreCompetencies': coreCompetencies,
        'certifications': certifications.map((c) => c.toJson()).toList(),
        'lastUpdated': lastUpdated?.toIso8601String(),
      };

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
        id: json['id'] as String,
        photoUrl: json['photoUrl'] as String?,
        personalInfo: PersonalInfo.fromJson(json['personalInfo']),
        education: (json['education'] as List)
            .map((e) => Education.fromJson(e))
            .toList(),
        careers:
            (json['careers'] as List).map((c) => Career.fromJson(c)).toList(),
        coreCompetencies: List<String>.from(json['coreCompetencies'] ?? []),
        certifications: (json['certifications'] as List)
            .map((c) => Certification.fromJson(c))
            .toList(),
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'])
            : null,
      );
}

class PersonalInfo {
  final String name;
  final String birthDate;
  final String address;
  final String militaryService;
  final String phone;
  final String email;

  const PersonalInfo({
    required this.name,
    required this.birthDate,
    required this.address,
    required this.militaryService,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate,
        'address': address,
        'militaryService': militaryService,
        'phone': phone,
        'email': email,
      };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        name: json['name'] as String,
        birthDate: json['birthDate'] as String,
        address: json['address'] as String,
        militaryService: json['militaryService'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
      );
}

class Education {
  final String period;
  final String institution;
  final String major;
  final String gpa;

  const Education({
    required this.period,
    required this.institution,
    required this.major,
    required this.gpa,
  });

  Map<String, dynamic> toJson() => {
        'period': period,
        'institution': institution,
        'major': major,
        'gpa': gpa,
      };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        period: json['period'] as String,
        institution: json['institution'] as String,
        major: json['major'] as String,
        gpa: json['gpa'] as String,
      );
}

class Career {
  final String period;
  final String company;
  final String department;
  final String position;
  final String role;
  final List<String> projects;
  final List<String> achievements;
  final List<String> tools;
  final String? environment;
  final String? resignationReason;

  const Career({
    required this.period,
    required this.company,
    required this.department,
    required this.position,
    required this.role,
    required this.projects,
    required this.achievements,
    required this.tools,
    this.environment,
    this.resignationReason,
  });

  Map<String, dynamic> toJson() => {
        'period': period,
        'company': company,
        'department': department,
        'position': position,
        'role': role,
        'projects': projects,
        'achievements': achievements,
        'tools': tools,
        'environment': environment,
        'resignationReason': resignationReason,
      };

  factory Career.fromJson(Map<String, dynamic> json) => Career(
        period: json['period'] as String,
        company: json['company'] as String,
        department: json['department'] as String,
        position: json['position'] as String,
        role: json['role'] as String,
        projects: List<String>.from(json['projects'] ?? []),
        achievements: List<String>.from(json['achievements'] ?? []),
        tools: List<String>.from(json['tools'] ?? []),
        environment: json['environment'] as String?,
        resignationReason: json['resignationReason'] as String?,
      );
}

class Certification {
  final String name;
  final String issuer;
  final String date;

  const Certification({
    required this.name,
    required this.issuer,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'issuer': issuer,
        'date': date,
      };

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
        name: json['name'] as String,
        issuer: json['issuer'] as String,
        date: json['date'] as String,
      );
}

class CoverLetterModel {
  final String id;
  final String greeting;
  final String background;
  final String personality;
  final String hobbies;
  final String aspiration;
  final DateTime? lastUpdated;

  const CoverLetterModel({
    required this.id,
    required this.greeting,
    required this.background,
    required this.personality,
    required this.hobbies,
    required this.aspiration,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'greeting': greeting,
        'background': background,
        'personality': personality,
        'hobbies': hobbies,
        'aspiration': aspiration,
        'lastUpdated': lastUpdated?.toIso8601String(),
      };

  factory CoverLetterModel.fromJson(Map<String, dynamic> json) =>
      CoverLetterModel(
        id: json['id'] as String,
        greeting: json['greeting'] as String,
        background: json['background'] as String,
        personality: json['personality'] as String,
        hobbies: json['hobbies'] as String,
        aspiration: json['aspiration'] as String,
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'])
            : null,
      );
}
