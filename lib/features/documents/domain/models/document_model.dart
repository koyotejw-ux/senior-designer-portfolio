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
  // 개인 문서
  resume('이력서', '공식 경력 요약서'),
  coverLetter('자기소개서', '인성 및 동기 소개'),
  careerDescription('경력기술서', '상세 프로젝트 경력'),
  portfolio('포트폴리오', '프로젝트 케이스 스터디'),

  // 기획/디자인 문서
  requirements('요구사항 정의서', '기능 및 비기능 요구사항 명세'),
  userFlow('사용자 플로우', '사용자 여정 및 인터랙션 흐름'),
  informationArchitecture('정보구조도', '콘텐츠 구조 및 네비게이션'),
  wireframe('와이어프레임', '화면 레이아웃 및 구조 설계'),

  // PM 문서
  projectCharter('프로젝트 헌장', '프로젝트 목표 및 범위 정의'),
  screenDesign('화면설계서', 'UI/UX 화면 설계 및 와이어프레임'),
  stakeholderMatrix('이해관계자 매트릭스', '이해관계자 분석 및 관리'),
  riskRegister('리스크 등록부', '리스크 식별 및 대응 계획'),
  changeLog('변경 이력', '프로젝트 변경사항 추적'),
  lessonsLearned('교훈 문서', '프로젝트 회고 및 개선사항');

  final String displayName;
  final String description;

  const DocumentType(this.displayName, this.description);
}
