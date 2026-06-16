import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Project Development Guide - 대기업 취업을 위한 프로젝트 수행 가이드
class ProjectGuidePage extends StatefulWidget {
  const ProjectGuidePage({super.key});

  @override
  State<ProjectGuidePage> createState() => _ProjectGuidePageState();
}

class _ProjectGuidePageState extends State<ProjectGuidePage> {
  int _selectedPhase = 0;

  final _phases = [
    '기획 & 분석',
    '디자인',
    '개발 준비',
    '백엔드 개발',
    '프론트엔드 개발',
    '테스트 & QA',
    '배포 & 운영',
    '포트폴리오 작성',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f3a),
        title: const Text(
          '🎯 대기업 취업 프로젝트 수행 가이드',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // Left: Phase Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              border: Border(
                right: BorderSide(color: Colors.cyan.withOpacity(0.3)),
              ),
            ),
            child: ListView.builder(
              itemCount: _phases.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedPhase == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPhase = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue.withOpacity(0.2) : null,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? AppColors.accentCyan : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accentCyan : Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _phases[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right: Phase Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: _buildPhaseContent(_selectedPhase),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(int phase) {
    switch (phase) {
      case 0:
        return _buildPlanningPhase();
      case 1:
        return _buildDesignPhase();
      case 2:
        return _buildDevPrepPhase();
      case 3:
        return _buildBackendPhase();
      case 4:
        return _buildFrontendPhase();
      case 5:
        return _buildTestingPhase();
      case 6:
        return _buildDeploymentPhase();
      case 7:
        return _buildPortfolioPhase();
      default:
        return const SizedBox();
    }
  }

  // Phase 1: 기획 & 분석
  Widget _buildPlanningPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '1단계: 기획 & 분석',
          '프로젝트의 목적과 범위를 명확히 정의합니다',
          Icons.lightbulb,
          Colors.yellow,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '1.1 프로젝트 목표 설정',
          [
            '• 왜 이 프로젝트를 하는가? (목적)',
            '• 누구를 위한 프로젝트인가? (타겟)',
            '• 어떤 문제를 해결하는가? (가치)',
            '',
            '📝 현재 프로젝트:',
            '- 목적: UX/UI 디자이너 포트폴리오 웹사이트',
            '- 타겟: 대기업 채용 담당자, HR',
            '- 가치: 17년 경력을 효과적으로 보여주는 전문적인 포트폴리오',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '1.2 요구사항 정의',
          [
            '★ 필수 기능 (Must Have):',
            '- 프로젝트 포트폴리오 갤러리',
            '- 경력 사항 (17년)',
            '- 학력 & 자격증',
            '- 기술 스택',
            '- 이력서 PDF 다운로드',
            '',
            '🎨 선택 기능 (Nice to Have):',
            '- 관리자 페이지',
            '- 다크모드',
            '- 애니메이션',
            '- 반응형 디자인',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '1.3 기술 스택 선정',
          [
            '프론트엔드: Flutter Web',
            '- 이유: 크로스 플랫폼, 빠른 개발, 아름다운 UI',
            '',
            '백엔드: Dart Shelf + JSON',
            '- 이유: 간단한 REST API, 빠른 프로토타입',
            '',
            '데이터: db.json (향후 Firebase 확장 가능)',
            '- 이유: 초기엔 간단히, 필요시 확장',
            '',
            '상태관리: Riverpod',
            '- 이유: Flutter 공식 추천, 강력한 상태 관리',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '1.4 일정 계획',
          [
            '주차별 목표:',
            '',
            '1주차: 기획 & 디자인',
            '- 요구사항 정의',
            '- 와이어프레임',
            '- 디자인 시스템',
            '',
            '2주차: 개발 환경 & 백엔드',
            '- Flutter 프로젝트 세팅',
            '- 서버 구축',
            '- API 개발',
            '',
            '3-4주차: 프론트엔드 개발',
            '- UI 컴포넌트',
            '- 페이지 구현',
            '- API 연동',
            '',
            '5주차: 테스트 & 배포',
            '- QA 테스트',
            '- 버그 수정',
            '- 배포',
          ],
          Colors.orange,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 명확한 목표 설정 능력',
            '✓ 체계적인 요구사항 분석',
            '✓ 합리적인 기술 스택 선정',
            '✓ 현실적인 일정 계획',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 2: 디자인
  Widget _buildDesignPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '2단계: 디자인',
          'UX/UI 디자인과 디자인 시스템을 구축합니다',
          Icons.palette,
          Colors.pink,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '2.1 정보 구조 설계 (IA)',
          [
            '사이트맵:',
            '',
            'Home',
            '├─ Hero Section (이름, 직무)',
            '├─ About Section (자기소개)',
            '├─ Experience Section (경력)',
            '├─ Portfolio Gallery (프로젝트)',
            '├─ Skills Section (기술 스택)',
            '└─ Resume Section (이력서 다운로드)',
            '',
            'Admin',
            '├─ Projects (프로젝트 관리)',
            '├─ Profile (프로필 수정)',
            '├─ Experience (경력 관리)',
            '├─ Education (학력 관리)',
            '├─ Skills (스킬 관리)',
            '└─ Resume (이력서 관리)',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '2.2 와이어프레임',
          [
            '각 페이지의 레이아웃을 스케치합니다:',
            '',
            '✏️ 저해상도 와이어프레임:',
            '- 종이/화이트보드에 손으로 그리기',
            '- 레이아웃 구조 파악',
            '- 콘텐츠 우선순위 정리',
            '',
            '🖥️ 고해상도 와이어프레임:',
            '- Figma로 정교하게 작업',
            '- 실제 크기와 간격 정의',
            '- 인터랙션 플로우',
            '',
            '📱 반응형 고려:',
            '- Mobile (< 768px)',
            '- Tablet (768px ~ 1024px)',
            '- Desktop (> 1024px)',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '2.3 디자인 시스템 구축',
          [
            '🎨 Foundation:',
            '- Color Palette (#0068B3, #009DDC, #C1D72E)',
            '- Typography (Inter, Pretendard)',
            '- Spacing (4px 기본 단위)',
            '- Grid System (12-column)',
            '',
            '🧩 Components:',
            '- Atoms (Button, Input, Icon)',
            '- Molecules (Card, SearchBar)',
            '- Organisms (Navigation, Gallery)',
            '',
            '📐 Design Tokens:',
            '- colors.json',
            '- typography.json',
            '- spacing.json',
            '',
            '👉 Admin → Design System 탭에서 확인!',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '2.4 UI 디자인 (Figma)',
          [
            'Figma에서 고품질 목업 제작:',
            '',
            '1. 아트보드 생성',
            '   - Desktop: 1920x1080',
            '   - Mobile: 375x812',
            '',
            '2. 디자인 시스템 적용',
            '   - Color Styles',
            '   - Text Styles',
            '   - Component Library',
            '',
            '3. 각 페이지 디자인',
            '   - Hero Section',
            '   - About Section',
            '   - Portfolio Gallery',
            '   - etc.',
            '',
            '4. 프로토타입',
            '   - 클릭 가능한 프로토타입',
            '   - 애니메이션 효과',
          ],
          Colors.pink,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 체계적인 정보 구조',
            '✓ 일관된 디자인 시스템',
            '✓ 접근성 고려 (WCAG AA)',
            '✓ 반응형 디자인',
            '✓ 사용자 중심 설계',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 3: 개발 준비
  Widget _buildDevPrepPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '3단계: 개발 준비',
          '개발 환경을 세팅하고 프로젝트 구조를 잡습니다',
          Icons.settings,
          Colors.orange,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '3.1 개발 환경 세팅',
          [
            '필수 도구 설치:',
            '',
            '✅ Flutter SDK',
            '   flutter doctor 실행하여 확인',
            '',
            '✅ IDE',
            '   - VS Code (추천)',
            '   - Android Studio',
            '   - 확장: Flutter, Dart',
            '',
            '✅ Git',
            '   - 버전 관리',
            '   - GitHub 레포지토리 생성',
            '',
            '✅ Postman',
            '   - API 테스트용',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '3.2 프로젝트 구조 설계',
          [
            'Feature-First 아키텍처:',
            '',
            'lib/',
            '├─ main.dart',
            '├─ core/               # 공통 모듈',
            '│   ├─ design_system/',
            '│   ├─ theme/',
            '│   ├─ constants/',
            '│   └─ router/',
            '├─ features/           # 기능별',
            '│   ├─ home/',
            '│   │   ├─ data/',
            '│   │   ├─ domain/',
            '│   │   └─ presentation/',
            '│   └─ admin/',
            '│       ├─ data/',
            '│       ├─ domain/',
            '│       └─ presentation/',
            '└─ shared/             # 공유 위젯',
            '',
            '👉 Admin → Structure 탭에서 상세 확인!',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '3.3 데이터 구조 설계',
          [
            'db.json 스키마 정의:',
            '',
            '{',
            '  "projects": [',
            '    {',
            '      "id": "string",',
            '      "title": "string",',
            '      "description": "string",',
            '      "category": "string",',
            '      "images": ["url"],',
            '      "tags": ["tag1"],',
            '      "period": "2024.01-2024.03",',
            '      "role": "UX/UI Designer",',
            '      "tools": ["Figma"],',
            '      "url": "https://..."',
            '    }',
            '  ],',
            '  "profile": { ... },',
            '  "experience": [ ... ],',
            '  "education": [ ... ],',
            '  "skills": [ ... ]',
            '}',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '3.4 Git 초기화 & 커밋',
          [
            'Git으로 버전 관리 시작:',
            '',
            '1. Git 초기화',
            '   git init',
            '',
            '2. .gitignore 설정',
            '   - Flutter 기본 gitignore 사용',
            '   - 민감한 정보 제외',
            '',
            '3. 초기 커밋',
            '   git add .',
            '   git commit -m "feat: Initial project setup"',
            '',
            '4. GitHub 연결',
            '   git remote add origin [repo-url]',
            '   git push -u origin master',
            '',
            '💡 커밋 컨벤션:',
            '   feat: 새 기능',
            '   fix: 버그 수정',
            '   docs: 문서 수정',
            '   style: 코드 포맷팅',
            '   refactor: 리팩토링',
          ],
          Colors.orange,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 체계적인 프로젝트 구조',
            '✓ Clean Architecture 이해',
            '✓ Git 사용 능력',
            '✓ 명확한 데이터 설계',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 4: 백엔드 개발
  Widget _buildBackendPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '4단계: 백엔드 개발',
          'REST API 서버를 구축합니다',
          Icons.dns,
          Colors.green,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '4.1 서버 프로젝트 생성',
          [
            'Dart Shelf 서버 세팅:',
            '',
            '1. 디렉토리 생성',
            '   mkdir server && cd server',
            '',
            '2. Dart 프로젝트 초기화',
            '   dart create -t server-shelf .',
            '',
            '3. 패키지 설치',
            '   pubspec.yaml에 추가:',
            '   - shelf',
            '   - shelf_router',
            '   - shelf_static',
            '',
            '4. 디렉토리 구조',
            '   server/',
            '   ├─ bin/',
            '   │   └─ server.dart',
            '   ├─ data/',
            '   │   ├─ db.json',
            '   │   └─ images/',
            '   └─ pubspec.yaml',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '4.2 REST API 구현',
          [
            'CRUD API 엔드포인트:',
            '',
            'GET    /api/projects        # 전체 조회',
            'GET    /api/projects/:id    # 단일 조회',
            'POST   /api/projects        # 생성',
            'PUT    /api/projects/:id    # 수정',
            'DELETE /api/projects/:id    # 삭제',
            '',
            'GET    /api/profile         # 프로필',
            'PUT    /api/profile         # 프로필 수정',
            '',
            'GET    /api/experience      # 경력',
            'POST   /api/experience      # 경력 추가',
            'PUT    /api/experience/:id  # 경력 수정',
            'DELETE /api/experience/:id  # 경력 삭제',
            '',
            '... (education, skills 동일)',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '4.3 파일 서빙',
          [
            '이미지 파일 제공:',
            '',
            'GET /images/:filename',
            '',
            '구현 예시:',
            'final imageHandler = createStaticHandler(',
            '  \'data/images\',',
            '  defaultDocument: \'index.html\',',
            ');',
            '',
            'router.mount(\'/images/\', imageHandler);',
            '',
            '📁 이미지 저장 위치:',
            'server/data/images/',
            '├─ profile.jpg',
            '├─ project1.jpg',
            '└─ project2.jpg',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '4.4 CORS 설정',
          [
            '프론트엔드 연동을 위한 CORS:',
            '',
            'final handler = Pipeline()',
            '  .addMiddleware(corsHeaders())',
            '  .addMiddleware(logRequests())',
            '  .addHandler(router);',
            '',
            'Middleware corsHeaders() {',
            '  return (handler) {',
            '    return (request) async {',
            '      final response = await handler(request);',
            '      return response.change(',
            '        headers: {',
            '          \'Access-Control-Allow-Origin\': \'*\',',
            '          \'Access-Control-Allow-Methods\': \'GET,POST,PUT,DELETE\',',
            '        },',
            '      );',
            '    };',
            '  };',
            '}',
          ],
          Colors.orange,
        ),

        _buildStepCard(
          '4.5 테스트 & 검증',
          [
            'Postman으로 API 테스트:',
            '',
            '1. 서버 실행',
            '   cd server',
            '   dart run bin/server.dart',
            '',
            '2. Postman 테스트',
            '   GET http://localhost:8080/api/projects',
            '   → 200 OK, JSON 응답 확인',
            '',
            '3. CRUD 모두 테스트',
            '   ✓ Create: POST로 데이터 추가',
            '   ✓ Read: GET으로 조회',
            '   ✓ Update: PUT으로 수정',
            '   ✓ Delete: DELETE로 삭제',
            '',
            '4. 에러 처리 확인',
            '   - 404: 없는 ID 조회',
            '   - 400: 잘못된 데이터',
            '   - 500: 서버 에러',
          ],
          Colors.red,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ RESTful API 설계 능력',
            '✓ 적절한 HTTP 메서드 사용',
            '✓ 에러 핸들링',
            '✓ API 문서화',
            '✓ 보안 고려 (CORS)',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 5: 프론트엔드 개발
  Widget _buildFrontendPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '5단계: 프론트엔드 개발',
          'Flutter로 UI를 구현하고 API와 연동합니다',
          Icons.web,
          Colors.blue,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '5.1 디자인 시스템 구현',
          [
            'Atoms부터 차근차근:',
            '',
            '1. Atoms (원자)',
            '   lib/core/design_system/atoms/',
            '   ├─ buttons/',
            '   │   ├─ primary_button.dart',
            '   │   └─ secondary_button.dart',
            '   └─ inputs/',
            '       └─ text_input.dart',
            '',
            '2. Molecules (분자)',
            '   lib/core/design_system/molecules/',
            '   └─ cards/',
            '       └─ info_card.dart',
            '',
            '3. Organisms (유기체)',
            '   lib/core/design_system/organisms/',
            '   ├─ navigation.dart',
            '   └─ footer.dart',
            '',
            '👉 Admin → Design System에서 확인!',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '5.2 데이터 계층 구현',
          [
            'Model → Repository → Provider:',
            '',
            '1️⃣ Model (데이터 구조)',
            '   lib/features/home/data/models/',
            '   └─ project_model.dart',
            '',
            '   class Project {',
            '     final String id;',
            '     final String title;',
            '     // ...',
            '     ',
            '     factory Project.fromJson(Map json)',
            '     Map<String, dynamic> toJson()',
            '   }',
            '',
            '2️⃣ Repository (API 통신)',
            '   lib/features/home/data/repositories/',
            '   └─ project_repository.dart',
            '',
            '   Future<List<Project>> getProjects()',
            '   Future<Project> getProject(String id)',
            '   Future<void> createProject(Project)',
            '   Future<void> updateProject(Project)',
            '   Future<void> deleteProject(String id)',
            '',
            '3️⃣ Provider (상태 관리)',
            '   lib/features/home/data/providers/',
            '   └─ project_provider.dart',
            '',
            '   final projectsProvider = FutureProvider(...)',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '5.3 페이지 구현',
          [
            '각 섹션을 하나씩 완성:',
            '',
            '✅ Hero Section',
            '   - 이름, 직무',
            '   - 애니메이션',
            '   - 반응형',
            '',
            '✅ About Section',
            '   - 자기소개',
            '   - 프로필 이미지',
            '',
            '✅ Experience Section',
            '   - 경력 타임라인',
            '   - 7개 경력 표시',
            '',
            '✅ Portfolio Gallery',
            '   - 프로젝트 카드',
            '   - 필터링',
            '   - 상세 페이지',
            '',
            '✅ Skills Section',
            '   - 기술 스택',
            '   - 숙련도',
            '',
            '✅ Resume Section',
            '   - PDF 다운로드',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '5.4 Admin 페이지 구현',
          [
            '관리자 기능:',
            '',
            '📋 Projects Tab',
            '   - 프로젝트 목록',
            '   - 추가/수정/삭제',
            '   - 이미지 업로드',
            '',
            '👤 Profile Tab',
            '   - 프로필 정보 수정',
            '',
            '💼 Experience Tab',
            '   - 경력 관리',
            '   - BMSoft, C&D 등',
            '',
            '🎓 Education Tab',
            '   - 학력 관리',
            '',
            '⭐ Skills Tab',
            '   - 기술 스택 관리',
            '',
            '📄 Resume Tab',
            '   - 이력서 PDF 생성',
            '   - 한글 폰트 지원',
          ],
          Colors.orange,
        ),

        _buildStepCard(
          '5.5 API 연동',
          [
            'Mock 데이터 → 실제 API:',
            '',
            '// Before (Mock)',
            'final projects = [',
            '  Project(id: \'1\', title: \'Test\'),',
            '];',
            '',
            '// After (Real API)',
            'final projectsAsync = ref.watch(',
            '  projectsProvider,',
            ');',
            '',
            'projectsAsync.when(',
            '  loading: () => CircularProgressIndicator(),',
            '  error: (e, s) => Text(\'Error: \$e\'),',
            '  data: (projects) => ListView(...),',
            ')',
            '',
            '✅ 체크리스트:',
            '   □ 로딩 상태',
            '   □ 에러 처리',
            '   □ 빈 데이터',
            '   □ 새로고침',
          ],
          Colors.cyan,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 컴포넌트 재사용성',
            '✓ 상태 관리 이해',
            '✓ API 연동 능력',
            '✓ 에러 핸들링',
            '✓ 반응형 디자인',
            '✓ 접근성',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 6: 테스트 & QA
  Widget _buildTestingPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '6단계: 테스트 & QA',
          '품질을 검증하고 버그를 수정합니다',
          Icons.bug_report,
          Colors.red,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '6.1 기능 테스트',
          [
            '모든 기능이 작동하는지 확인:',
            '',
            '✅ Home 페이지',
            '   □ Hero Section 애니메이션',
            '   □ About Section 표시',
            '   □ Experience 7개 표시',
            '   □ Portfolio 필터링',
            '   □ Skills 표시',
            '   □ Resume PDF 다운로드',
            '',
            '✅ Admin 페이지',
            '   □ 프로젝트 CRUD',
            '   □ 프로필 수정',
            '   □ 경력 관리',
            '   □ 학력 관리',
            '   □ 스킬 관리',
            '   □ 이력서 PDF 생성',
            '',
            '✅ 데이터 동기화',
            '   □ Admin 수정 → Front 자동 업데이트',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '6.2 반응형 테스트',
          [
            '다양한 화면 크기 테스트:',
            '',
            '📱 Mobile (375px)',
            '   □ 세로 레이아웃',
            '   □ 터치 영역 (최소 44x44)',
            '   □ 읽기 편한 폰트 크기',
            '   □ 스크롤 동작',
            '',
            '📱 Tablet (768px)',
            '   □ 2단 레이아웃',
            '   □ 적절한 여백',
            '',
            '💻 Desktop (1920px)',
            '   □ 가로 레이아웃',
            '   □ 최대 너비 제한',
            '',
            '🔧 Chrome DevTools 활용:',
            '   F12 → Device Toolbar (Ctrl+Shift+M)',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '6.3 브라우저 호환성',
          [
            '주요 브라우저 테스트:',
            '',
            '✅ Chrome (권장)',
            '   - 최신 버전',
            '   - Flutter Web 최적화',
            '',
            '✅ Safari',
            '   - iOS/Mac 사용자',
            '   - WebKit 엔진',
            '',
            '✅ Edge',
            '   - Windows 기본 브라우저',
            '',
            '✅ Firefox',
            '   - 일부 사용자',
            '',
            '⚠️ 확인 사항:',
            '   □ 레이아웃 깨짐',
            '   □ 폰트 렌더링',
            '   □ 애니메이션',
            '   □ 이미지 로딩',
          ],
          Colors.orange,
        ),

        _buildStepCard(
          '6.4 성능 테스트',
          [
            'Lighthouse 점수 확인:',
            '',
            'Chrome DevTools → Lighthouse → Generate Report',
            '',
            '🎯 목표 점수:',
            '   Performance: 90+',
            '   Accessibility: 90+',
            '   Best Practices: 90+',
            '   SEO: 80+',
            '',
            '⚡ 최적화:',
            '   □ 이미지 압축 (WebP)',
            '   □ 지연 로딩',
            '   □ 코드 스플리팅',
            '   □ 캐싱',
            '',
            '📊 로딩 시간:',
            '   FCP (First Contentful Paint): < 1.8s',
            '   LCP (Largest Contentful Paint): < 2.5s',
            '   TTI (Time to Interactive): < 3.8s',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '6.5 접근성 테스트',
          [
            'WCAG 2.1 AA 기준:',
            '',
            '⌨️ 키보드 내비게이션',
            '   □ Tab으로 모든 요소 접근',
            '   □ Enter/Space로 버튼 클릭',
            '   □ Esc로 모달 닫기',
            '',
            '👁️ 스크린 리더',
            '   □ Alt 텍스트',
            '   □ Semantic HTML',
            '   □ ARIA 레이블',
            '',
            '🎨 색상 대비',
            '   □ 텍스트: 4.5:1 이상',
            '   □ 대형 텍스트: 3:1 이상',
            '',
            '🔍 확대/축소',
            '   □ 200% 확대 가능',
            '   □ 레이아웃 깨지지 않음',
          ],
          Colors.cyan,
        ),

        _buildStepCard(
          '6.6 버그 트래킹',
          [
            '발견된 버그 기록 & 수정:',
            '',
            '📝 Bug Template:',
            '',
            '제목: [페이지] 간단한 설명',
            '심각도: Critical / High / Medium / Low',
            '재현 단계:',
            '  1. ...',
            '  2. ...',
            '예상 동작: ...',
            '실제 동작: ...',
            '스크린샷: ...',
            '환경: Chrome 120, Windows 11',
            '',
            '💡 GitHub Issues 활용:',
            '   - Label로 분류',
            '   - Milestone로 그룹핑',
            '   - 수정 후 Close',
          ],
          Colors.red,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 체계적인 테스트 프로세스',
            '✓ 품질 기준 (Lighthouse 90+)',
            '✓ 접근성 준수',
            '✓ 버그 관리 능력',
            '✓ 성능 최적화',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 7: 배포 & 운영
  Widget _buildDeploymentPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '7단계: 배포 & 운영',
          '프로젝트를 실제로 배포하고 운영합니다',
          Icons.rocket_launch,
          Colors.purple,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '7.1 빌드',
          [
            'Flutter Web 빌드:',
            '',
            '1. 릴리즈 빌드',
            '   flutter build web --release',
            '',
            '2. 빌드 결과',
            '   build/web/',
            '   ├─ index.html',
            '   ├─ main.dart.js',
            '   ├─ assets/',
            '   └─ canvaskit/',
            '',
            '3. 빌드 옵션',
            '   --web-renderer html     # HTML 렌더러',
            '   --web-renderer canvaskit # CanvasKit (권장)',
            '',
            '4. 최적화',
            '   --dart-define=FLUTTER_WEB_USE_SKIA=true',
            '   --source-maps           # 디버깅용',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '7.2 호스팅 선택',
          [
            '추천 호스팅 서비스:',
            '',
            '🌐 Firebase Hosting (무료)',
            '   + 빠른 CDN',
            '   + 무료 SSL',
            '   + 쉬운 배포',
            '   - 백엔드 별도 필요',
            '',
            '🌐 Vercel (무료)',
            '   + Git 연동',
            '   + 자동 배포',
            '   + 미리보기',
            '   - 백엔드 제한적',
            '',
            '🌐 Netlify (무료)',
            '   + 간단한 설정',
            '   + Form 처리',
            '   - 빌드 시간 제한',
            '',
            '🌐 GitHub Pages (무료)',
            '   + GitHub 통합',
            '   + 간단한 설정',
            '   - 정적 사이트만',
            '',
            '💡 추천: Firebase (프론트) + Railway/Render (백엔드)',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '7.3 Firebase 배포',
          [
            'Firebase Hosting 배포 과정:',
            '',
            '1. Firebase CLI 설치',
            '   npm install -g firebase-tools',
            '',
            '2. 로그인',
            '   firebase login',
            '',
            '3. 프로젝트 초기화',
            '   firebase init hosting',
            '   - Public directory: build/web',
            '   - SPA: Yes',
            '   - GitHub: No (일단)',
            '',
            '4. 배포',
            '   firebase deploy --only hosting',
            '',
            '5. 확인',
            '   https://your-project.web.app',
            '',
            '6. 커스텀 도메인 (선택)',
            '   Firebase Console → Hosting → Add Custom Domain',
          ],
          Colors.orange,
        ),

        _buildStepCard(
          '7.4 백엔드 배포',
          [
            'Dart 서버 배포:',
            '',
            '🚀 Railway (추천)',
            '   1. GitHub에 server 코드 푸시',
            '   2. Railway 연결',
            '   3. Start Command 설정',
            '      dart run bin/server.dart',
            '   4. 환경변수 설정',
            '   5. 배포 URL 획득',
            '',
            '🚀 Render',
            '   1. GitHub 연결',
            '   2. Dockerfile 작성',
            '   3. 자동 배포',
            '',
            '🚀 Heroku',
            '   1. heroku create',
            '   2. Procfile 작성',
            '   3. git push heroku master',
            '',
            '⚙️ 프론트에서 API URL 변경',
            '   const baseUrl = "https://your-api.railway.app";',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '7.5 CI/CD 설정',
          [
            'GitHub Actions로 자동 배포:',
            '',
            '.github/workflows/deploy.yml',
            '',
            'name: Deploy',
            'on:',
            '  push:',
            '    branches: [master]',
            '',
            'jobs:',
            '  deploy:',
            '    runs-on: ubuntu-latest',
            '    steps:',
            '      - uses: actions/checkout@v2',
            '      - uses: subosito/flutter-action@v2',
            '      - run: flutter build web --release',
            '      - uses: FirebaseExtended/action-hosting-deploy@v0',
            '        with:',
            '          firebaseServiceAccount: \${{ secrets.FIREBASE_TOKEN }}',
            '',
            '💡 이제 master에 push만 하면 자동 배포!',
          ],
          Colors.cyan,
        ),

        _buildStepCard(
          '7.6 모니터링',
          [
            '운영 중 모니터링:',
            '',
            '📊 Firebase Analytics',
            '   - 방문자 수',
            '   - 페이지뷰',
            '   - 사용자 행동',
            '',
            '🐛 Sentry (에러 추적)',
            '   - 실시간 에러 감지',
            '   - 스택 트레이스',
            '   - 알림',
            '',
            '⚡ Lighthouse CI',
            '   - 성능 모니터링',
            '   - 자동 리포트',
            '',
            '📈 Google Search Console',
            '   - SEO 모니터링',
            '   - 검색 노출',
            '',
            '🔔 알림 설정',
            '   - 에러 발생 시 이메일',
            '   - 성능 저하 시 알림',
          ],
          Colors.red,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 배포 프로세스 이해',
            '✓ CI/CD 구축 능력',
            '✓ 모니터링 & 운영',
            '✓ 도메인 & SSL 설정',
            '✓ 성능 최적화',
          ],
          Colors.cyan,
        ),
      ],
    );
  }

  // Phase 8: 포트폴리오 작성
  Widget _buildPortfolioPhase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseHeader(
          '8단계: 포트폴리오 작성',
          '프로젝트를 효과적으로 정리하고 발표합니다',
          Icons.description,
          Colors.pink,
        ),
        const SizedBox(height: 24),

        _buildStepCard(
          '8.1 프로젝트 문서화',
          [
            'README.md 작성:',
            '',
            '# 프로젝트명',
            '',
            '## 🎯 프로젝트 개요',
            '- 목적: ...',
            '- 기간: 2024.01 - 2024.03',
            '- 역할: UX/UI 디자인 & 1인 풀스택 개발',
            '',
            '## 🛠️ 기술 스택',
            '- Frontend: Flutter Web, Riverpod',
            '- Backend: Dart Shelf, REST API',
            '- Design: Figma, Atomic Design',
            '- Deploy: Firebase Hosting',
            '',
            '## ✨ 주요 기능',
            '- 포트폴리오 갤러리',
            '- 경력 관리 시스템',
            '- PDF 이력서 생성',
            '- 관리자 대시보드',
            '',
            '## 📊 성과',
            '- Lighthouse 성능 점수: 95',
            '- 반응형 지원: Mobile/Tablet/Desktop',
            '- 접근성: WCAG AA 준수',
            '',
            '## 🔗 링크',
            '- 배포 URL: https://...',
            '- GitHub: https://github.com/...',
          ],
          Colors.blue,
        ),

        _buildStepCard(
          '8.2 케이스 스터디 작성',
          [
            '프로젝트 스토리 정리:',
            '',
            '📝 구성:',
            '',
            '1. 문제 정의',
            '   "17년 경력을 효과적으로 보여줄 포트폴리오가 필요했다"',
            '',
            '2. 리서치',
            '   - 대기업 채용 담당자 인터뷰',
            '   - 경쟁사 포트폴리오 분석',
            '   - 사용자 니즈 파악',
            '',
            '3. 디자인 프로세스',
            '   - IA 설계',
            '   - 와이어프레임',
            '   - 디자인 시스템',
            '   - 고품질 UI 디자인',
            '',
            '4. 개발 과정',
            '   - 기술 스택 선정 이유',
            '   - 아키텍처 설계',
            '   - 주요 기술적 도전과 해결',
            '',
            '5. 결과 & 성과',
            '   - Lighthouse 95점',
            '   - 접근성 AA 준수',
            '   - 채용 담당자 피드백',
            '',
            '6. 회고 & 배운 점',
            '   - 잘한 점',
            '   - 아쉬운 점',
            '   - 다음 프로젝트 개선점',
          ],
          Colors.purple,
        ),

        _buildStepCard(
          '8.3 스크린샷 & 영상',
          [
            '시각 자료 준비:',
            '',
            '📸 스크린샷:',
            '   - Desktop (1920x1080)',
            '   - Tablet (768x1024)',
            '   - Mobile (375x812)',
            '   - Admin 페이지',
            '   - 주요 기능별',
            '',
            '🎬 데모 영상:',
            '   - 1-2분 짧게',
            '   - 주요 기능 시연',
            '   - 반응형 동작',
            '   - 관리자 기능',
            '',
            '🎨 Before/After:',
            '   - 와이어프레임 → 완성',
            '   - 디자인 → 구현',
            '',
            '💡 도구:',
            '   - 스크린샷: Chrome DevTools',
            '   - 화면 녹화: OBS Studio',
            '   - 편집: DaVinci Resolve',
            '   - GIF: ScreenToGif',
          ],
          Colors.green,
        ),

        _buildStepCard(
          '8.4 GitHub 정리',
          [
            'GitHub을 포트폴리오로:',
            '',
            '📌 Repository 정리:',
            '   ✓ README.md 상세 작성',
            '   ✓ LICENSE 추가',
            '   ✓ .gitignore 정리',
            '   ✓ 불필요한 파일 제거',
            '',
            '🏷️ Topic Tags 추가:',
            '   - flutter',
            '   - portfolio',
            '   - ux-design',
            '   - web-development',
            '   - dart',
            '',
            '📊 GitHub Profile:',
            '   - 프로필 사진',
            '   - Bio 작성',
            '   - Pinned Repositories (이 프로젝트)',
            '   - Contribution Graph 활성화',
            '',
            '📝 Commit History:',
            '   - 의미있는 커밋 메시지',
            '   - 규칙적인 커밋',
            '   - feat/fix/docs 등 컨벤션 준수',
          ],
          Colors.orange,
        ),

        _buildStepCard(
          '8.5 발표 자료 준비',
          [
            '면접/발표용 자료:',
            '',
            '🎤 PT 구성 (5분):',
            '',
            '1분: 프로젝트 소개',
            '   - 배경 & 목적',
            '   - 타겟 사용자',
            '',
            '2분: 기술적 하이라이트',
            '   - 아키텍처',
            '   - 핵심 기술',
            '   - 기술적 도전',
            '',
            '1분: 디자인 과정',
            '   - 디자인 시스템',
            '   - UX 개선사항',
            '',
            '30초: 성과',
            '   - 성능 지표',
            '   - 사용자 피드백',
            '',
            '30초: 배운 점',
            '   - 기술 성장',
            '   - 다음 목표',
            '',
            '💡 예상 질문 대비:',
            '   Q: 왜 Flutter를 선택했나요?',
            '   Q: 가장 어려웠던 기술적 도전은?',
            '   Q: 1인 개발의 장단점은?',
            '   Q: 다음엔 뭘 개선하고 싶나요?',
          ],
          Colors.cyan,
        ),

        _buildStepCard(
          '8.6 이력서 업데이트',
          [
            '이력서에 프로젝트 추가:',
            '',
            '📄 프로젝트 섹션:',
            '',
            '프로젝트명: Senior Designer Portfolio',
            '기간: 2024.01 - 2024.03 (3개월)',
            '역할: UX/UI Design & Full-Stack Development',
            '',
            '주요 업무:',
            '• UX/UI 디자인 (Figma, Atomic Design System)',
            '• Flutter Web 프론트엔드 개발',
            '• Dart Shelf 백엔드 API 개발',
            '• Firebase Hosting 배포 및 운영',
            '• 반응형 디자인 구현 (Mobile/Tablet/Desktop)',
            '',
            '기술 스택:',
            'Flutter, Dart, Riverpod, REST API, Firebase',
            '',
            '성과:',
            '• Lighthouse 성능 점수 95점 달성',
            '• WCAG AA 접근성 기준 준수',
            '• 1인 풀스택 개발로 3개월 내 완성',
            '',
            '링크:',
            'https://your-portfolio.web.app',
            'https://github.com/username/project',
          ],
          Colors.red,
        ),

        _buildActionBox(
          '💼 대기업이 보는 포인트',
          [
            '✓ 명확한 문제 정의 & 해결 과정',
            '✓ 기술적 깊이와 폭',
            '✓ 성과 지표 (숫자로 증명)',
            '✓ 회고 & 학습 능력',
            '✓ 커뮤니케이션 능력',
            '✓ GitHub 활동성',
          ],
          Colors.cyan,
        ),

        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.2),
                AppColors.accentCyan.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.celebration, color: Colors.yellow, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '🎉 축하합니다!',
                    style: TextStyle(
                      color: AppColors.accentCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '이 8단계를 완료하셨다면, 대기업 취업을 위한 완벽한 포트폴리오 프로젝트를 완성하신 겁니다!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '✨ 핵심 체크리스트:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...[
                '✓ 명확한 프로젝트 목표와 성과',
                '✓ 체계적인 개발 프로세스',
                '✓ 깔끔한 코드와 아키텍처',
                '✓ 실제 배포된 서비스',
                '✓ 상세한 문서화',
                '✓ 효과적인 발표 준비',
              ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 12),
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              )),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '💡 마지막 팁: 이 프로젝트를 진행하면서 "왜 이 방식을 선택했는지", "어떤 문제를 어떻게 해결했는지"를 명확히 설명할 수 있어야 합니다. 기술 자체보다 문제 해결 과정이 더 중요합니다!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseHeader(String title, String description, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(String title, List<String> items, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
                fontFamily: 'monospace',
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionBox(String title, List<String> items, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(0.2),
            accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
