class DocumentModel {
  final String id;
  final DocumentType type;
  final String title;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? pdfUrl;
  final Map<String, dynamic> content;
  final List<String> tags;

  const DocumentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.pdfUrl,
    required this.content,
    this.tags = const [],
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DocumentType.resume,
      ),
      title: json['title'] as String,
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      pdfUrl: json['pdfUrl'] as String?,
      content: json['content'] as Map<String, dynamic>,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pdfUrl': pdfUrl,
      'content': content,
      'tags': tags,
    };
  }
}

enum DocumentType {
  resume('이력서', '공식 경력 요약서'),
  coverLetter('자기소개서', '인성 및 동기 소개'),
  careerDescription('경력기술서', '상세 프로젝트 경력'),
  portfolio('포트폴리오', '프로젝트 케이스 스터디');

  final String displayName;
  final String description;

  const DocumentType(this.displayName, this.description);
}
