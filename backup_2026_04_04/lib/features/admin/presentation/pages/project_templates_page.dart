import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/editable_document.dart';

class ProjectTemplatesPage extends StatefulWidget {
  const ProjectTemplatesPage({super.key});

  @override
  State<ProjectTemplatesPage> createState() => _ProjectTemplatesPageState();
}

class _ProjectTemplatesPageState extends State<ProjectTemplatesPage> {
  int _selectedIndex = 0;

  void _showUserGuide() {
    showDialog(
      context: context,
      builder: (context) => _UserGuideDialog(),
    );
  }

  final List<Map<String, dynamic>> _templates = [
    {
      'category': '기획 문서',
      'icon': Icons.lightbulb,
      'color': AppColors.primaryBlue,
      'documents': [
        {
          'title': '1. 프로젝트 제안서 (Project Proposal)',
          'fields': {
            '1. 프로젝트 개요': '''프로젝트명: Senior Designer Portfolio
프로젝트 기간: 2025.01 ~ 2025.03 (3개월)
프로젝트 유형: 개인 포트폴리오 웹사이트
담당 역할: 기획 / 디자인 / 개발 (1인 풀스택)''',
            '2. 프로젝트 배경': '''[문제 정의]
• 기존 포트폴리오의 한계: 정적인 PDF 형식으로 인터랙티브한 경험 부족
• 대기업 지원 시 차별화 필요: 디자인 + 개발 역량을 동시에 증명 필요
• 프로젝트 관리 경험 부족: 체계적인 개발 프로세스 경험 필요

[기회 요소]
• Flutter Web 기술로 크로스플랫폼 경험 제공 가능
• 현대적인 디자인 시스템 구축으로 전문성 증명
• Admin 기능으로 실시간 콘텐츠 관리 역량 증명''',
            '3. 프로젝트 목표': '''[비즈니스 목표]
• 대기업 UX 디자이너 포지션 지원용 포트폴리오 구축
• 디자인 + 개발 통합 역량 증명
• 프로젝트 수행 능력 증명

[기술적 목표]
• Flutter Web 기반 반응형 포트폴리오 사이트 개발
• Atomic Design System 구축
• REST API 백엔드 개발 (Dart Shelf)
• Firebase Hosting 배포

[성과 지표 (KPI)]
• Lighthouse 성능 점수: 90점 이상
• 반응형 지원: Mobile / Tablet / Desktop
• 접근성: WCAG 2.1 AA 준수
• 로딩 속도: 3초 이내''',
            '4. 타겟 사용자': '''[Primary Persona]
• 대기업 채용 담당자
• 역할: HR 매니저, 디자인 팀 리더
• 니즈: 디자인 역량 + 개발 이해도를 모두 확인하고 싶음
• 행동: 포트폴리오를 5분 이내로 빠르게 스캔

[Secondary Persona]
• 동료 디자이너 / 개발자
• 역할: 커뮤니티 멤버
• 니즈: 영감과 레퍼런스 탐색
• 행동: 프로젝트 상세 내용과 디자인 시스템 탐색''',
            '5. 주요 기능': '''[핵심 기능 (Must Have)]
✓ 포트폴리오 프로젝트 갤러리 (카테고리별 필터링)
✓ 프로젝트 상세 페이지 (이미지, 설명, 기술 스택)
✓ About 섹션 (프로필, 경력, 학력)
✓ Skills 섹션 (기술 스택 시각화)
✓ Resume 다운로드 (PDF)
✓ Admin 페이지 (콘텐츠 관리 CRUD)
✓ 반응형 디자인 (Mobile / Tablet / Desktop)

[부가 기능 (Nice to Have)]
○ 다크모드 / 라이트모드 토글
○ 애니메이션 및 인터랙션
○ 다국어 지원 (한국어 / 영어)
○ 프로젝트 검색 기능
○ 방문자 통계 (Google Analytics)''',
            '6. 기술 스택': '''[Frontend]
• Framework: Flutter Web
• 상태관리: Riverpod
• 라우팅: go_router
• 애니메이션: flutter_animate

[Backend]
• Framework: Dart Shelf
• Database: JSON 파일 (db.json)
• API: RESTful API

[Design]
• 디자인 툴: Figma
• 디자인 시스템: Atomic Design
• 컬러: 다크 테마 기반 (네온 액센트)

[Deployment]
• Frontend: Firebase Hosting
• Backend: Railway / Render
• CI/CD: GitHub Actions

[선정 이유]
• Flutter Web: 크로스플랫폼, 고성능 애니메이션, 빠른 개발
• Dart Shelf: 가벼운 백엔드, Flutter와 언어 통일
• Firebase: 무료 호스팅, 빠른 배포, 높은 안정성''',
            '7. 일정 계획': '''[Phase 1: 기획 & 디자인] (Week 1-2)
• 요구사항 정의 및 정보 구조 설계
• 와이어프레임 제작
• UI 디자인 (Figma)
• 디자인 시스템 구축

[Phase 2: 개발 환경 구축] (Week 3)
• Flutter 프로젝트 생성
• 폴더 구조 설계 (Clean Architecture)
• Git 초기화 및 브랜치 전략 수립
• 백엔드 서버 구축 (Dart Shelf)

[Phase 3: 프론트엔드 개발] (Week 4-7)
• 디자인 시스템 컴포넌트 구현
• 메인 페이지 개발 (Hero, About, Portfolio, Skills)
• 프로젝트 상세 페이지 개발
• Admin 페이지 개발 (CRUD 기능)

[Phase 4: 백엔드 개발] (Week 8)
• REST API 엔드포인트 구현
• 데이터베이스 스키마 설계
• API 문서화

[Phase 5: 테스트 & QA] (Week 9-10)
• 기능 테스트
• 반응형 테스트
• 성능 최적화 (Lighthouse)
• 접근성 테스트 (WCAG)

[Phase 6: 배포 & 런칭] (Week 11-12)
• Firebase Hosting 배포
• 백엔드 배포 (Railway)
• 도메인 연결
• 최종 점검 및 런칭''',
            '8. 예산 및 리소스': '''[비용 (월간)]
• Firebase Hosting: \$0 (무료 플랜)
• Backend Hosting (Railway): \$0 (무료 플랜)
• 도메인: \$10/year
• 디자인 툴 (Figma): \$0 (무료 플랜)
• 총 비용: ~\$1/month

[인력]
• 1인 개발 (기획 / 디자인 / 개발)
• 주당 투입 시간: 20시간
• 총 투입 시간: 240시간 (12주 × 20시간)

[도구 및 환경]
• 개발 환경: VS Code
• 디자인 툴: Figma
• 버전 관리: Git / GitHub
• 프로젝트 관리: GitHub Projects''',
            '9. 위험 요소 및 대응 방안': '''[기술적 위험]
• Flutter Web 성능 이슈
  → 대응: 이미지 최적화, 코드 스플리팅, 레이지 로딩

• 브라우저 호환성 문제
  → 대응: Chrome, Safari, Edge, Firefox 테스트

[일정 위험]
• 기능 구현 지연
  → 대응: MVP 우선, Nice to Have 기능은 후순위

[운영 위험]
• 무료 플랜 제한
  → 대응: 트래픽 모니터링, 필요 시 유료 플랜 전환''',
            '10. 기대 효과': '''[단기 효과]
• 대기업 지원용 포트폴리오 완성
• Flutter + Dart 기술 역량 증명
• 프로젝트 수행 경험 축적

[중기 효과]
• 취업 성공 (목표: 대기업 UX 디자이너)
• 포트폴리오를 통한 네트워킹 기회

[장기 효과]
• 개인 브랜딩 구축
• 지속적인 포트폴리오 업데이트 기반 마련
• 향후 프로젝트의 레퍼런스''',
          },
        },
        {
          'title': '2. 요구사항 명세서 (SRS - Software Requirements Specification)',
          'fields': {
            '1. 문서 정보': '''문서명: 요구사항 명세서 (SRS)
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025-01-15
작성자: [이름]
검토자: [검토자]
승인자: [승인자]''',
            '2. 서론': '''[2.1 목적]
본 문서는 Senior Designer Portfolio 웹사이트의 요구사항을 정의합니다.
대상 독자: 개발자, 디자이너, 프로젝트 관리자, QA 엔지니어

[2.2 범위]
• 포트폴리오 전시 웹사이트
• 관리자 콘텐츠 관리 시스템
• 반응형 웹 디자인 (Mobile / Tablet / Desktop)

[2.3 정의 및 약어]
• SRS: Software Requirements Specification
• CRUD: Create, Read, Update, Delete
• API: Application Programming Interface
• UI: User Interface
• UX: User Experience
• WCAG: Web Content Accessibility Guidelines''',
            '3. 전체 설명': '''[3.1 제품 관점]
독립적인 웹 애플리케이션으로, 외부 시스템과의 통합 없음.
Flutter Web 프레임워크 기반, REST API 백엔드 연동.

[3.2 제품 기능]
1. 포트폴리오 갤러리 (카테고리별 필터링)
2. 프로젝트 상세 페이지
3. About / Skills / Resume 섹션
4. Admin 콘텐츠 관리 (CRUD)
5. 반응형 디자인

[3.3 사용자 클래스 및 특성]
• 일반 방문자: 포트폴리오 열람 (읽기 전용)
• 관리자: 콘텐츠 편집 (CRUD 권한)

[3.4 운영 환경]
• 클라이언트: 웹 브라우저 (Chrome, Safari, Edge, Firefox)
• 서버: Firebase Hosting (프론트엔드), Railway (백엔드)

[3.5 설계 및 구현 제약사항]
• Flutter Web 프레임워크 사용 필수
• 모바일 우선 반응형 디자인
• WCAG 2.1 AA 접근성 준수
• Lighthouse 성능 점수 90점 이상''',
            '4. 기능 요구사항': '''[FR-001] 포트폴리오 갤러리
• 우선순위: 높음 (High)
• 설명: 프로젝트 목록을 카드 형태로 표시
• 입력: 없음
• 출력: 프로젝트 카드 리스트
• 상세:
  - 카테고리별 필터링 (All / Brand / Product / Editorial)
  - 각 카드는 이미지, 제목, 부제목, 연도 표시
  - 호버 시 그라데이션 효과
• 예외: 프로젝트가 없을 경우 "No projects" 메시지

[FR-002] 프로젝트 상세 페이지
• 우선순위: 높음 (High)
• 설명: 개별 프로젝트의 상세 정보 표시
• 입력: 프로젝트 ID
• 출력: 프로젝트 상세 화면
• 상세:
  - 프로젝트 이미지 갤러리
  - 제목, 설명, 기술 스택, 기간, 역할
  - 이전/다음 프로젝트 네비게이션
• 예외: 존재하지 않는 ID → 404 페이지

[FR-003] About 섹션
• 우선순위: 중간 (Medium)
• 설명: 프로필, 경력, 학력 정보 표시
• 입력: 없음
• 출력: About 섹션
• 상세:
  - 프로필 사진 및 간단한 소개
  - 경력 타임라인 (회사, 기간, 역할)
  - 학력 정보
• 예외: 없음

[FR-004] Skills 섹션
• 우선순위: 중간 (Medium)
• 설명: 보유 기술 스택을 카테고리별로 표시
• 입력: 없음
• 출력: 스킬 카드 리스트
• 상세:
  - Design Tools (Figma, Adobe XD, etc.)
  - Development (Flutter, React, etc.)
  - Collaboration (Jira, Slack, etc.)
• 예외: 없음

[FR-005] Resume 다운로드
• 우선순위: 중간 (Medium)
• 설명: 이력서를 PDF로 다운로드
• 입력: 다운로드 버튼 클릭
• 출력: PDF 파일
• 상세:
  - 이력서, 경력증명서, 자기소개서 옵션
  - 한글 폰트 지원
• 예외: PDF 생성 실패 → 에러 메시지

[FR-006] Admin - 프로젝트 관리 (CRUD)
• 우선순위: 높음 (High)
• 설명: 프로젝트를 생성, 조회, 수정, 삭제
• 입력: 프로젝트 데이터 (제목, 설명, 이미지 등)
• 출력: 성공/실패 메시지
• 상세:
  - 프로젝트 목록 조회
  - 새 프로젝트 추가 (모달 다이얼로그)
  - 기존 프로젝트 수정
  - 프로젝트 삭제 (확인 다이얼로그)
  - 드래그 앤 드롭으로 순서 변경
• 예외: 필수 항목 누락 → 유효성 검사 에러

[FR-007] Admin - 프로필/경력/학력/스킬 관리
• 우선순위: 중간 (Medium)
• 설명: About 섹션 콘텐츠 관리
• 입력: 각 섹션별 데이터
• 출력: 성공/실패 메시지
• 상세:
  - 프로필 정보 수정
  - 경력 추가/수정/삭제
  - 학력 추가/수정/삭제
  - 스킬 추가/수정/삭제
• 예외: 유효성 검사 실패 → 에러 메시지''',
            '5. 비기능 요구사항': '''[NFR-001] 성능
• Lighthouse 성능 점수: 90점 이상
• 페이지 로딩 시간: 3초 이내 (First Contentful Paint)
• 이미지 최적화: WebP 포맷, Lazy Loading

[NFR-002] 보안
• HTTPS 필수
• XSS 공격 방어
• SQL Injection 방어 (해당 없음 - JSON DB)
• Admin 페이지 접근 제어 (추후 인증 추가)

[NFR-003] 접근성
• WCAG 2.1 AA 준수
• 키보드 네비게이션 지원
• 스크린 리더 호환성
• 색상 대비율 4.5:1 이상

[NFR-004] 사용성
• 직관적인 네비게이션
• 일관된 디자인 시스템
• 명확한 피드백 (로딩, 에러)
• 모바일 터치 최적화

[NFR-005] 호환성
• 브라우저: Chrome 90+, Safari 14+, Edge 90+, Firefox 88+
• 디바이스: Mobile (375px~), Tablet (768px~), Desktop (1024px~)
• 반응형 레이아웃

[NFR-006] 유지보수성
• Clean Architecture (Feature-First)
• 코드 문서화 (주석)
• Git 커밋 메시지 규칙
• 재사용 가능한 컴포넌트

[NFR-007] 확장성
• 모듈식 구조
• 새로운 프로젝트 추가 용이
• 디자인 시스템 확장 가능''',
            '6. 인터페이스 요구사항': '''[6.1 사용자 인터페이스]
• 다크 테마 기반 UI
• 네온 블루/퍼플 액센트 컬러
• Pretendard 폰트 사용
• 애니메이션: fade-in, slide, hover effects

[6.2 하드웨어 인터페이스]
• 없음 (웹 애플리케이션)

[6.3 소프트웨어 인터페이스]
• REST API 통신
• HTTP 메서드: GET, POST, PUT, DELETE
• 데이터 형식: JSON
• API Base URL: http://localhost:8080/api

[6.4 통신 인터페이스]
• HTTPS 프로토콜
• CORS 설정 (Cross-Origin Resource Sharing)''',
            '7. 데이터 요구사항': '''[7.1 프로젝트 데이터 모델]
{
  "id": "string (UUID)",
  "title": "string",
  "subtitle": "string",
  "company": "string",
  "year": "string",
  "category": "string (Brand|Product|Editorial)",
  "description": "string",
  "tags": ["string"],
  "imageUrl": "string (URL)",
  "gradientColors": ["string (hex color)"],
  "order": "number"
}

[7.2 프로필 데이터 모델]
{
  "name": "string",
  "title": "string",
  "bio": "string",
  "email": "string",
  "phone": "string",
  "photo": "string (URL)"
}

[7.3 경력 데이터 모델]
{
  "id": "string",
  "company": "string",
  "position": "string",
  "startDate": "string (YYYY-MM)",
  "endDate": "string (YYYY-MM)",
  "description": "string"
}

[7.4 데이터 저장]
• 백엔드: JSON 파일 (db.json)
• 구조: { "projects": [], "profile": {}, "experiences": [], "education": [], "skills": [] }''',
            '8. 제약사항': '''[8.1 기술 제약]
• Flutter Web 프레임워크 사용 필수
• Dart 언어 사용
• Firebase Hosting 배포

[8.2 비즈니스 제약]
• 무료 호스팅 플랜 사용
• 1인 개발
• 3개월 개발 기간

[8.3 법적 제약]
• 개인정보 보호법 준수
• 저작권 있는 이미지 사용 금지
• 오픈소스 라이선스 준수''',
            '9. 부록': '''[9.1 용어 정의]
• Portfolio: 프로젝트 작품 모음
• CRUD: Create, Read, Update, Delete 기본 데이터 조작
• REST API: REpresentational State Transfer API
• SPA: Single Page Application

[9.2 참고 자료]
• Flutter 공식 문서: https://flutter.dev
• Dart 공식 문서: https://dart.dev
• WCAG 2.1 가이드라인: https://www.w3.org/WAI/WCAG21/

[9.3 변경 이력]
v1.0 (2025-01-15): 초기 문서 작성''',
          },
        },
        {
          'title': '3. WBS (Work Breakdown Structure)',
          'fields': {
            '1. 프로젝트 정보': '''프로젝트명: Senior Designer Portfolio
총 기간: 12주 (2025.01.15 ~ 2025.04.07)
담당자: [이름]
상태: In Progress''',
            '2. WBS 레벨 1 - Phase 1: 기획 & 디자인 (2주)': '''기간: Week 1-2 (2025.01.15 ~ 2025.01.28)
담당: [이름]
상태: Completed

[1.1] 프로젝트 기획
• 1.1.1 프로젝트 제안서 작성 (2일)
• 1.1.2 요구사항 정의 (SRS) (2일)
• 1.1.3 정보 구조 설계 (IA, Sitemap) (1일)
• 1.1.4 사용자 시나리오 작성 (1일)

[1.2] 디자인 시스템 구축
• 1.2.1 컬러 팔레트 정의 (1일)
• 1.2.2 타이포그래피 시스템 (1일)
• 1.2.3 간격 시스템 (Spacing) (0.5일)
• 1.2.4 컴포넌트 인벤토리 (0.5일)

[1.3] UI 디자인
• 1.3.1 와이어프레임 - 저해상도 (2일)
• 1.3.2 와이어프레임 - 고해상도 (2일)
• 1.3.3 UI 디자인 - 메인 페이지 (3일)
• 1.3.4 UI 디자인 - 상세 페이지 (2일)
• 1.3.5 UI 디자인 - Admin 페이지 (2일)

산출물:
✓ 프로젝트 제안서
✓ 요구사항 명세서 (SRS)
✓ Sitemap & IA
✓ Figma 디자인 파일''',
            '3. WBS 레벨 1 - Phase 2: 개발 환경 구축 (1주)': '''기간: Week 3 (2025.01.29 ~ 2025.02.04)
담당: [이름]
상태: Completed

[2.1] 프론트엔드 환경
• 2.1.1 Flutter 프로젝트 생성 (0.5일)
• 2.1.2 폴더 구조 설계 (Feature-First) (1일)
• 2.1.3 필요 패키지 설치 (Riverpod, go_router 등) (0.5일)
• 2.1.4 라우팅 설정 (1일)

[2.2] 백엔드 환경
• 2.2.1 Dart Shelf 프로젝트 생성 (0.5일)
• 2.2.2 REST API 구조 설계 (1일)
• 2.2.3 데이터베이스 스키마 설계 (db.json) (1일)
• 2.2.4 CORS 설정 (0.5일)

[2.3] 버전 관리
• 2.3.1 Git 저장소 초기화 (0.5일)
• 2.3.2 .gitignore 설정 (0.5일)
• 2.3.3 브랜치 전략 수립 (main, develop, feature/*) (0.5일)
• 2.3.4 초기 커밋 (0.5일)

산출물:
✓ Flutter 프로젝트 구조
✓ Dart Shelf 백엔드 서버
✓ Git 저장소
✓ 아키텍처 문서''',
            '4. WBS 레벨 1 - Phase 3: 프론트엔드 개발 (4주)': '''기간: Week 4-7 (2025.02.05 ~ 2025.03.04)
담당: [이름]
상태: In Progress

[3.1] 디자인 시스템 구현 (Week 4)
• 3.1.1 Foundation (Colors, Typography) (1일)
• 3.1.2 Atoms (Buttons, Inputs) (2일)
• 3.1.3 Molecules (Cards, Forms) (2일)
• 3.1.4 Organisms (Navigation, Footer) (2일)

[3.2] 메인 페이지 개발 (Week 5)
• 3.2.1 Hero Section (2일)
• 3.2.2 About Section (1일)
• 3.2.3 Portfolio Gallery Section (2일)
• 3.2.4 Skills Section (1일)
• 3.2.5 Resume Section (1일)

[3.3] 프로젝트 상세 페이지 (Week 6)
• 3.3.1 프로젝트 상세 레이아웃 (1일)
• 3.3.2 이미지 갤러리 (2일)
• 3.3.3 이전/다음 네비게이션 (1일)
• 3.3.4 관련 프로젝트 추천 (1일)

[3.4] Admin 페이지 (Week 7)
• 3.4.1 Admin 레이아웃 & 탭 구조 (1일)
• 3.4.2 프로젝트 CRUD (2일)
• 3.4.3 프로필/경력/학력 CRUD (2일)
• 3.4.4 스킬 CRUD (1일)
• 3.4.5 Resume 편집기 (1일)

산출물:
✓ 디자인 시스템 컴포넌트 라이브러리
✓ 메인 페이지
✓ 프로젝트 상세 페이지
✓ Admin CRUD 페이지''',
            '5. WBS 레벨 1 - Phase 4: 백엔드 개발 (1주)': '''기간: Week 8 (2025.03.05 ~ 2025.03.11)
담당: [이름]
상태: Pending

[4.1] REST API 구현
• 4.1.1 Projects API (GET, POST, PUT, DELETE) (2일)
• 4.1.2 Profile API (GET, PUT) (1일)
• 4.1.3 Experience API (GET, POST, PUT, DELETE) (1일)
• 4.1.4 Education API (GET, POST, PUT, DELETE) (1일)
• 4.1.5 Skills API (GET, POST, PUT, DELETE) (1일)

[4.2] 파일 처리
• 4.2.1 이미지 업로드 (1일)
• 4.2.2 이미지 서빙 (정적 파일) (0.5일)
• 4.2.3 PDF 생성 (Resume) (1일)

[4.3] API 문서화
• 4.3.1 API 명세서 작성 (1일)
• 4.3.2 Postman Collection (0.5일)

산출물:
✓ REST API 서버
✓ API 명세서
✓ Postman Collection''',
            '6. WBS 레벨 1 - Phase 5: 테스트 & QA (2주)': '''기간: Week 9-10 (2025.03.12 ~ 2025.03.25)
담당: [이름]
상태: Pending

[5.1] 기능 테스트 (Week 9)
• 5.1.1 메인 페이지 기능 테스트 (1일)
• 5.1.2 프로젝트 상세 페이지 테스트 (1일)
• 5.1.3 Admin CRUD 테스트 (2일)
• 5.1.4 API 통합 테스트 (1일)
• 5.1.5 에러 핸들링 테스트 (1일)

[5.2] 반응형 & 호환성 테스트 (Week 9)
• 5.2.1 Mobile 테스트 (375px, 414px) (1일)
• 5.2.2 Tablet 테스트 (768px, 1024px) (1일)
• 5.2.3 Desktop 테스트 (1280px, 1920px) (1일)
• 5.2.4 브라우저 테스트 (Chrome, Safari, Edge, Firefox) (2일)

[5.3] 성능 & 접근성 테스트 (Week 10)
• 5.3.1 Lighthouse 성능 측정 (0.5일)
• 5.3.2 이미지 최적화 (1일)
• 5.3.3 코드 스플리팅 (1일)
• 5.3.4 레이지 로딩 적용 (1일)
• 5.3.5 WCAG 접근성 테스트 (1일)
• 5.3.6 키보드 네비게이션 테스트 (0.5일)

[5.4] 버그 수정 (Week 10)
• 5.4.1 Critical 버그 수정 (2일)
• 5.4.2 Major 버그 수정 (1일)
• 5.4.3 Minor 버그 수정 (0.5일)

산출물:
✓ 테스트 계획서
✓ 테스트 결과 보고서
✓ Lighthouse 성능 리포트
✓ 버그 트래킹 시트''',
            '7. WBS 레벨 1 - Phase 6: 배포 & 런칭 (2주)': '''기간: Week 11-12 (2025.03.26 ~ 2025.04.07)
담당: [이름]
상태: Pending

[6.1] 프론트엔드 배포 (Week 11)
• 6.1.1 Flutter Web 빌드 (flutter build web --release) (0.5일)
• 6.1.2 Firebase Hosting 설정 (1일)
• 6.1.3 도메인 연결 (1일)
• 6.1.4 SSL 인증서 설정 (0.5일)
• 6.1.5 배포 테스트 (1일)

[6.2] 백엔드 배포 (Week 11)
• 6.2.1 Railway 계정 설정 (0.5일)
• 6.2.2 Dart Shelf 배포 (1일)
• 6.2.3 환경 변수 설정 (0.5일)
• 6.2.4 데이터베이스 마이그레이션 (1일)
• 6.2.5 API 연동 테스트 (1일)

[6.3] CI/CD 설정 (Week 11)
• 6.3.1 GitHub Actions 워크플로우 작성 (1일)
• 6.3.2 자동 빌드 & 테스트 (1일)
• 6.3.3 자동 배포 (1일)

[6.4] 모니터링 & 분석 (Week 12)
• 6.4.1 Google Analytics 설정 (0.5일)
• 6.4.2 Sentry 에러 모니터링 설정 (0.5일)
• 6.4.3 Lighthouse CI 설정 (0.5일)

[6.5] 최종 점검 & 런칭 (Week 12)
• 6.5.1 전체 기능 최종 점검 (1일)
• 6.5.2 성능 최종 점검 (0.5일)
• 6.5.3 보안 점검 (0.5일)
• 6.5.4 공식 런칭 (0.5일)

산출물:
✓ 배포 가이드
✓ CI/CD 파이프라인
✓ 모니터링 대시보드
✓ 런칭 체크리스트''',
            '8. WBS 요약 - 전체 일정 개요': '''[전체 타임라인]
Phase 1: 기획 & 디자인          Week 1-2   (14일)
Phase 2: 개발 환경 구축         Week 3     (7일)
Phase 3: 프론트엔드 개발        Week 4-7   (28일)
Phase 4: 백엔드 개발            Week 8     (7일)
Phase 5: 테스트 & QA            Week 9-10  (14일)
Phase 6: 배포 & 런칭            Week 11-12 (14일)
─────────────────────────────────────────
총 기간: 12주 (84일)

[인력 투입]
• 1인 풀타임 (기획 / 디자인 / 개발)
• 주당 40시간 (평일 8시간 × 5일)
• 총 투입 시간: 480시간

[주요 마일스톤]
M1: 디자인 완료               (Week 2 종료)
M2: 개발 환경 구축 완료       (Week 3 종료)
M3: 프론트엔드 개발 완료      (Week 7 종료)
M4: 백엔드 개발 완료          (Week 8 종료)
M5: QA 완료                   (Week 10 종료)
M6: 공식 런칭                 (Week 12 종료)

[위험 요소 및 버퍼]
• 각 Phase 종료 시 1일 버퍼 포함
• 예상치 못한 기술적 이슈 대응 (Week 10에 2일 여유)
• 디자인 수정 요청 대응 (Phase 1에 1일 여유)''',
            '9. WBS 상세 - 주간 계획 예시 (Week 4)': '''Week 4: 디자인 시스템 구현 (2025.02.05 ~ 2025.02.11)

[월요일 - 2025.02.05]
• 09:00-10:00: 주간 계획 수립
• 10:00-12:00: Foundation 구현 (Colors)
• 13:00-17:00: Foundation 구현 (Typography, Spacing)
• 17:00-18:00: 코드 리뷰 & Git 커밋

[화요일 - 2025.02.06]
• 09:00-12:00: Atoms 구현 (PrimaryButton, SecondaryButton)
• 13:00-17:00: Atoms 구현 (TextInput, Checkbox)
• 17:00-18:00: 스토리북 문서화

[수요일 - 2025.02.07]
• 09:00-12:00: Atoms 구현 (Badge, Chip, Avatar)
• 13:00-17:00: Molecules 구현 (InfoCard)
• 17:00-18:00: 컴포넌트 테스트

[목요일 - 2025.02.08]
• 09:00-12:00: Molecules 구현 (SearchBar, Pagination)
• 13:00-17:00: Organisms 구현 (Navigation)
• 17:00-18:00: 반응형 테스트

[금요일 - 2025.02.09]
• 09:00-12:00: Organisms 구현 (Footer, Hero Section)
• 13:00-17:00: 디자인 시스템 문서화
• 17:00-18:00: 주간 회고 & 다음 주 계획

산출물:
✓ 디자인 시스템 컴포넌트 (Foundation, Atoms, Molecules, Organisms)
✓ 컴포넌트 문서화 (Storybook 또는 Admin UI Preview)
✓ Git 커밋 로그''',
          },
        },
      ],
    },
    {
      'category': '디자인 문서',
      'icon': Icons.palette,
      'color': AppColors.accentCyan,
      'documents': [
        {
          'title': '1. 디자인 시스템 가이드',
          'fields': {
            '1. 문서 정보': '''문서명: 디자인 시스템 가이드
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025-01-20
작성자: [디자이너 이름]
대상: 개발자, 디자이너, PM''',
            '2. 디자인 시스템 개요': '''[2.1 목적]
일관된 사용자 경험과 효율적인 협업을 위한 디자인 시스템 가이드

[2.2 디자인 철학]
• Minimalism: 불필요한 요소 제거, 핵심에 집중
• Dark Elegance: 다크 테마 기반의 세련된 느낌
• Sci-Fi Touch: 홀로그래픽, 네온 효과로 미래적 분위기
• Accessibility First: 모든 사용자가 접근 가능한 디자인

[2.3 디자인 원칙]
1. Consistency (일관성): 동일한 패턴 반복 사용
2. Clarity (명확성): 명확한 정보 전달
3. Efficiency (효율성): 빠른 작업 완료
4. Feedback (피드백): 사용자 행동에 즉각 반응
5. Accessibility (접근성): 누구나 사용 가능''',
            '3. Foundation - Color System': '''[3.1 Primary Colors]
Deep Space: #0A0E27 (배경)
Charcoal: #1a1f3a (카드 배경)
Primary Blue: #4A90E2 (주요 액션)
Accent Purple: #B565D8 (강조 요소)

[3.2 Functional Colors]
Highlight Green: #00FF9D (성공, 완료)
Warning: #FFA726 (경고)
Error: #FF5252 (오류)

[3.3 Neutral Colors]
Light Gray 100: #E8E9ED (밝은 텍스트 배경)
Light Gray 200: #C5C7CD (비활성 텍스트)
Light Gray 300: #9FA2AB (구분선)

[3.4 사용 규칙]
• 배경: Deep Space (#0A0E27)
• 카드/컨테이너: Charcoal (#1a1f3a)
• 주요 버튼: Primary Blue (#4A90E2)
• 강조 요소: Accent Purple (#B565D8)
• 성공 메시지: Highlight Green (#00FF9D)
• 텍스트: White (#FFFFFF) / Light Gray 200

[3.5 색상 대비율 (WCAG AA 준수)]
• White on Deep Space: 15.8:1 ✓
• Primary Blue on Deep Space: 4.9:1 ✓
• Light Gray 200 on Deep Space: 7.2:1 ✓''',
            '4. Foundation - Typography': '''[4.1 Font Family]
Primary: Pretendard (한글/영문)
Fallback: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif
Code: "Courier New", monospace

[4.2 Type Scale]
H1 (Headline 1): 64px / Bold / -1.0 letter-spacing
H2 (Headline 2): 48px / Bold / -0.5 letter-spacing
H3 (Headline 3): 36px / SemiBold / -0.5 letter-spacing
H4 (Headline 4): 28px / SemiBold / -0.5 letter-spacing
H5 (Headline 5): 24px / Medium / -0.5 letter-spacing
H6 (Headline 6): 20px / Medium / -0.3 letter-spacing

Body Large: 18px / Regular / line-height 1.6
Body Medium: 16px / Regular / line-height 1.5
Body Small: 14px / Regular / line-height 1.4

Caption: 12px / Regular / line-height 1.3

[4.3 Font Weight]
Light: 300
Regular: 400
Medium: 500
SemiBold: 600
Bold: 700

[4.4 사용 규칙]
• 제목: H1-H6, Bold/SemiBold
• 본문: Body Large/Medium, Regular
• 캡션/라벨: Body Small/Caption, Regular
• 코드: Monospace, Regular''',
            '5. Foundation - Spacing System': '''[5.1 Spacing Scale (4px 기반)]
xs: 4px   (작은 간격)
sm: 8px   (좁은 간격)
md: 16px  (기본 간격)
lg: 24px  (넓은 간격)
xl: 32px  (매우 넓은 간격)
2xl: 48px (섹션 간격)
3xl: 64px (대형 섹션 간격)

[5.2 Component Spacing]
• 버튼 내부 여백: 12px 16px (sm lg)
• 카드 내부 여백: 24px (lg)
• 섹션 간격: 64px (3xl)
• 요소 간격: 16px (md)

[5.3 Grid System]
• Mobile: 1 column, 24px margin
• Tablet: 2-3 columns, 32px margin
• Desktop: 12 columns, 80px margin
• Max Width: 1200px''',
            '6. Foundation - Effects & Motion': '''[6.1 Border Radius]
xs: 4px   (작은 요소)
sm: 8px   (버튼, 입력 필드)
md: 12px  (카드)
lg: 16px  (큰 카드)
xl: 24px  (모달)
full: 9999px (원형)

[6.2 Shadows]
Shadow 1: 0 2px 8px rgba(0,0,0,0.1)    (작은 요소)
Shadow 2: 0 4px 16px rgba(0,0,0,0.15)  (카드)
Shadow 3: 0 8px 32px rgba(0,0,0,0.2)   (모달)
Glow: 0 0 20px rgba(74,144,226,0.3)    (네온 효과)

[6.3 Animation]
Duration Fast: 200ms (버튼 호버)
Duration Normal: 300ms (페이드)
Duration Slow: 500ms (슬라이드)
Easing: cubic-bezier(0.4, 0.0, 0.2, 1)

[6.4 Transitions]
• Hover: transform scale(1.02) + shadow
• Active: transform scale(0.98)
• Focus: border glow effect
• Page: fade-in 300ms''',
            '7. Components - Atoms': '''[7.1 Primary Button]
스타일:
• Background: Linear Gradient (Primary Blue → Accent Purple)
• Text: White, 16px, Medium
• Padding: 12px 24px
• Border Radius: 8px
• Shadow: Shadow 2
• Hover: Scale 1.05 + Shadow 3

[7.2 Secondary Button]
스타일:
• Background: Transparent
• Border: 2px Primary Blue
• Text: Primary Blue, 16px, Medium
• Padding: 10px 22px
• Border Radius: 8px
• Hover: Background Primary Blue 10%

[7.3 Text Input]
스타일:
• Background: Charcoal
• Border: 1px Light Gray 300
• Text: White, 16px
• Padding: 12px
• Border Radius: 8px
• Focus: Border Primary Blue 2px + Glow

[7.4 Checkbox]
스타일:
• Size: 20px × 20px
• Border: 2px Light Gray 300
• Checked: Background Primary Blue
• Border Radius: 4px''',
            '8. Components - Molecules': '''[8.1 Info Card]
구성:
• Container: Charcoal background, Shadow 2
• Title: H6, White
• Content: Body Medium, Light Gray 200
• Action: Primary Button
• Padding: 24px
• Border Radius: 12px

[8.2 Search Bar]
구성:
• Input: Text Input
• Icon: Search icon (Left)
• Button: Primary Button (Right)
• Width: 100% (Mobile), 400px (Desktop)

[8.3 Pagination]
구성:
• Numbers: Body Medium
• Active: Primary Blue background
• Inactive: Light Gray 300
• Hover: Primary Blue 20%''',
            '9. Components - Organisms': '''[9.1 Navigation]
구성:
• Container: Charcoal, Fixed top
• Logo: Left aligned
• Menu Items: Right aligned, Body Large
• Mobile: Hamburger menu
• Height: 80px
• Shadow: Shadow 1

[9.2 Footer]
구성:
• Container: Charcoal
• Content: 3 columns (Desktop), 1 column (Mobile)
• Text: Body Small, Light Gray 200
• Links: Primary Blue on hover
• Padding: 48px 24px

[9.3 Hero Section]
구성:
• Container: Full viewport height
• Logo: SVG, 420px (Desktop), 240px (Mobile)
• Subtitle: H4, Light Gray 200
• 3D Object: Right side (Desktop), Top (Mobile)
• Animation: Fade-in + Slide''',
            '10. 반응형 디자인': '''[10.1 Breakpoints]
Mobile: < 768px
Tablet: 768px ~ 1023px
Desktop: ≥ 1024px

[10.2 Mobile (< 768px)]
• 1 column layout
• 24px side margin
• Stacked navigation
• Full-width buttons
• Font scale: 0.875 (87.5%)

[10.3 Tablet (768px ~ 1023px)]
• 2-3 column layout
• 32px side margin
• Horizontal navigation
• Flexible buttons
• Font scale: 0.9375 (93.75%)

[10.4 Desktop (≥ 1024px)]
• 12 column grid
• 80px side margin
• Full navigation
• Optimal button sizes
• Font scale: 1.0 (100%)''',
            '11. 접근성 (Accessibility)': '''[11.1 WCAG 2.1 AA 준수]
• 색상 대비율: 최소 4.5:1
• 키보드 네비게이션: Tab, Enter, Space
• 스크린 리더: ARIA 레이블
• Focus Indicator: 명확한 포커스 표시

[11.2 키보드 내비게이션]
• Tab: 다음 요소로 이동
• Shift + Tab: 이전 요소로 이동
• Enter: 버튼/링크 활성화
• Space: 체크박스 토글
• Esc: 모달 닫기

[11.3 ARIA 속성]
• aria-label: 요소 설명
• aria-hidden: 장식 요소 숨김
• role: 요소 역할 정의
• aria-live: 동적 콘텐츠 알림''',
            '12. 디자인 파일 구조': '''[12.1 Figma 파일 구조]
📁 Design System
  ├─ 📄 Foundation (Colors, Typography, Spacing)
  ├─ 📄 Atoms (Buttons, Inputs, Icons)
  ├─ 📄 Molecules (Cards, Forms, Lists)
  └─ 📄 Organisms (Navigation, Footer, Hero)

📁 Pages
  ├─ 📄 Main Page (Hero, About, Portfolio, Skills)
  ├─ 📄 Project Detail
  └─ 📄 Admin

📁 Prototypes
  ├─ 📄 Desktop Flow
  ├─ 📄 Tablet Flow
  └─ 📄 Mobile Flow

[12.2 Component Naming]
형식: [Type]/[Category]/[Name]/[Variant]
예시:
• Atom/Button/Primary/Default
• Atom/Button/Primary/Hover
• Molecule/Card/Info/Large
• Organism/Navigation/Header/Desktop''',
          },
        },
      ],
    },
    {
      'category': '개발 문서',
      'icon': Icons.code,
      'color': AppColors.highlightGreen,
      'documents': [
        {
          'title': '1. API 명세서 (API Specification)',
          'fields': {
            '1. 문서 정보': '''문서명: REST API 명세서
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025-01-25
작성자: [개발자 이름]
Base URL: http://localhost:8080/api
Protocol: HTTP/HTTPS''',
            '2. API 개요': '''[2.1 목적]
Senior Designer Portfolio의 백엔드 REST API 명세서

[2.2 API 설계 원칙]
• RESTful 아키텍처 준수
• JSON 데이터 형식
• HTTP 메서드 (GET, POST, PUT, DELETE) 사용
• 명확한 엔드포인트 네이밍
• 일관된 응답 구조

[2.3 공통 응답 형식]
성공 응답:
{
  "success": true,
  "data": { ... },
  "message": "Success message"
}

에러 응답:
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}''',
            '3. 인증 및 보안': '''[3.1 인증 방식]
현재: 없음 (개발 단계)
향후: JWT (JSON Web Token) 인증 예정

[3.2 CORS 설정]
• Allow-Origin: * (개발), https://yourdomain.com (프로덕션)
• Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
• Allow-Headers: Content-Type, Authorization

[3.3 보안 고려사항]
• HTTPS 필수 (프로덕션)
• Input Validation (모든 입력값 검증)
• XSS 방어
• SQL Injection 방어 (해당 없음 - JSON DB)
• Rate Limiting (향후 추가 예정)''',
            '4. 엔드포인트 - Projects': '''[4.1] GET /api/projects
설명: 전체 프로젝트 목록 조회

요청:
GET /api/projects
Query Parameters:
  - category (optional): Brand|Product|Editorial

응답 예시:
{
  "success": true,
  "data": [
    {
      "id": "uuid-1",
      "title": "Brand Identity System",
      "subtitle": "Modern brand design",
      "company": "ABC Company",
      "year": "2024",
      "category": "Brand",
      "description": "Complete brand system...",
      "tags": ["Branding", "Identity"],
      "imageUrl": "http://localhost:8080/images/project1.jpg",
      "gradientColors": ["#4A90E2", "#B565D8"],
      "order": 0
    }
  ]
}

에러 코드:
• 500: 서버 내부 오류

─────────────────────────────────────

[4.2] GET /api/projects/:id
설명: 특정 프로젝트 상세 조회

요청:
GET /api/projects/uuid-1

응답 예시:
{
  "success": true,
  "data": {
    "id": "uuid-1",
    "title": "Brand Identity System",
    "subtitle": "Modern brand design",
    ...
  }
}

에러 코드:
• 404: 프로젝트를 찾을 수 없음
• 500: 서버 내부 오류

─────────────────────────────────────

[4.3] POST /api/projects
설명: 새 프로젝트 생성

요청:
POST /api/projects
Content-Type: application/json

Body:
{
  "title": "New Project",
  "subtitle": "Project subtitle",
  "company": "Company Name",
  "year": "2024",
  "category": "Brand",
  "description": "Description...",
  "tags": ["Tag1", "Tag2"],
  "imageUrl": "http://...",
  "gradientColors": ["#4A90E2", "#B565D8"]
}

응답:
{
  "success": true,
  "data": {
    "id": "uuid-new",
    ...
  },
  "message": "Project created successfully"
}

에러 코드:
• 400: 잘못된 요청 (필수 필드 누락)
• 500: 서버 내부 오류

─────────────────────────────────────

[4.4] PUT /api/projects/:id
설명: 프로젝트 수정

요청:
PUT /api/projects/uuid-1
Content-Type: application/json

Body:
{
  "title": "Updated Title",
  "subtitle": "Updated subtitle",
  ...
}

응답:
{
  "success": true,
  "data": { ... },
  "message": "Project updated successfully"
}

에러 코드:
• 400: 잘못된 요청
• 404: 프로젝트를 찾을 수 없음
• 500: 서버 내부 오류

─────────────────────────────────────

[4.5] DELETE /api/projects/:id
설명: 프로젝트 삭제

요청:
DELETE /api/projects/uuid-1

응답:
{
  "success": true,
  "message": "Project deleted successfully"
}

에러 코드:
• 404: 프로젝트를 찾을 수 없음
• 500: 서버 내부 오류''',
            '5. 엔드포인트 - Profile': '''[5.1] GET /api/profile
설명: 프로필 정보 조회

요청:
GET /api/profile

응답 예시:
{
  "success": true,
  "data": {
    "name": "John Doe",
    "title": "Senior UX Designer",
    "bio": "Passionate about design...",
    "email": "john@example.com",
    "phone": "+82-10-1234-5678",
    "photo": "http://localhost:8080/images/profile.jpg"
  }
}

─────────────────────────────────────

[5.2] PUT /api/profile
설명: 프로필 정보 수정

요청:
PUT /api/profile
Content-Type: application/json

Body:
{
  "name": "John Doe",
  "title": "Senior UX Designer",
  "bio": "Updated bio...",
  "email": "john@example.com",
  "phone": "+82-10-1234-5678",
  "photo": "http://..."
}

응답:
{
  "success": true,
  "data": { ... },
  "message": "Profile updated successfully"
}''',
            '6. 엔드포인트 - Experience': '''[6.1] GET /api/experiences
설명: 전체 경력 목록 조회

응답:
{
  "success": true,
  "data": [
    {
      "id": "exp-1",
      "company": "ABC Company",
      "position": "Senior UX Designer",
      "startDate": "2022-01",
      "endDate": "2024-12",
      "description": "Led UX design team..."
    }
  ]
}

─────────────────────────────────────

[6.2] POST /api/experiences
설명: 새 경력 추가

Body:
{
  "company": "Company Name",
  "position": "Position",
  "startDate": "YYYY-MM",
  "endDate": "YYYY-MM",
  "description": "Description..."
}

─────────────────────────────────────

[6.3] PUT /api/experiences/:id
설명: 경력 정보 수정

─────────────────────────────────────

[6.4] DELETE /api/experiences/:id
설명: 경력 삭제''',
            '7. 엔드포인트 - Education': '''[7.1] GET /api/education
설명: 전체 학력 목록 조회

응답:
{
  "success": true,
  "data": [
    {
      "id": "edu-1",
      "school": "University Name",
      "degree": "Bachelor's Degree",
      "major": "Design",
      "startDate": "2018-03",
      "endDate": "2022-02",
      "description": "GPA: 4.0/4.5"
    }
  ]
}

─────────────────────────────────────

[7.2] POST /api/education
설명: 새 학력 추가

[7.3] PUT /api/education/:id
설명: 학력 정보 수정

[7.4] DELETE /api/education/:id
설명: 학력 삭제''',
            '8. 엔드포인트 - Skills': '''[8.1] GET /api/skills
설명: 전체 스킬 목록 조회

응답:
{
  "success": true,
  "data": [
    {
      "id": "skill-1",
      "name": "Figma",
      "category": "Design Tools",
      "level": "Advanced",
      "icon": "figma.svg"
    }
  ]
}

─────────────────────────────────────

[8.2] POST /api/skills
설명: 새 스킬 추가

Body:
{
  "name": "Figma",
  "category": "Design Tools",
  "level": "Advanced",
  "icon": "figma.svg"
}

─────────────────────────────────────

[8.3] PUT /api/skills/:id
설명: 스킬 정보 수정

[8.4] DELETE /api/skills/:id
설명: 스킬 삭제''',
            '9. 데이터 모델': '''[9.1] Project Model
{
  "id": "string (UUID)",
  "title": "string (required)",
  "subtitle": "string",
  "company": "string",
  "year": "string",
  "category": "string (Brand|Product|Editorial)",
  "description": "string",
  "tags": ["string"],
  "imageUrl": "string (URL)",
  "gradientColors": ["string (hex)"],
  "order": "number"
}

[9.2] Profile Model
{
  "name": "string",
  "title": "string",
  "bio": "string",
  "email": "string (email format)",
  "phone": "string",
  "photo": "string (URL)"
}

[9.3] Experience Model
{
  "id": "string",
  "company": "string",
  "position": "string",
  "startDate": "string (YYYY-MM)",
  "endDate": "string (YYYY-MM)",
  "description": "string"
}

[9.4] Education Model
{
  "id": "string",
  "school": "string",
  "degree": "string",
  "major": "string",
  "startDate": "string (YYYY-MM)",
  "endDate": "string (YYYY-MM)",
  "description": "string"
}

[9.5] Skill Model
{
  "id": "string",
  "name": "string",
  "category": "string",
  "level": "string (Beginner|Intermediate|Advanced|Expert)",
  "icon": "string (URL)"
}''',
            '10. 에러 코드': '''[HTTP Status Codes]
200 OK: 성공
201 Created: 리소스 생성 성공
400 Bad Request: 잘못된 요청
401 Unauthorized: 인증 실패
403 Forbidden: 권한 없음
404 Not Found: 리소스를 찾을 수 없음
500 Internal Server Error: 서버 내부 오류

[Custom Error Codes]
VALIDATION_ERROR: 입력값 검증 실패
NOT_FOUND: 리소스를 찾을 수 없음
DUPLICATE_ENTRY: 중복된 항목
DATABASE_ERROR: 데이터베이스 오류
FILE_UPLOAD_ERROR: 파일 업로드 실패

[Error Response 예시]
{
  "success": false,
  "error": "Validation failed: title is required",
  "code": "VALIDATION_ERROR",
  "details": {
    "field": "title",
    "message": "Title is required"
  }
}''',
            '11. Rate Limiting': '''[11.1 Rate Limit 정책 (향후 구현)]
• 일반 사용자: 100 requests / hour
• Admin: 1000 requests / hour
• 초과 시: HTTP 429 (Too Many Requests)

[11.2 Response Headers]
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000

[11.3 Rate Limit 에러]
{
  "success": false,
  "error": "Rate limit exceeded",
  "code": "RATE_LIMIT_EXCEEDED",
  "retryAfter": 3600
}''',
            '12. Postman Collection': '''[12.1 Postman 사용법]
1. Postman 설치 (https://www.postman.com)
2. Collection Import
3. Environment 설정 (BASE_URL = http://localhost:8080/api)
4. 각 엔드포인트 테스트

[12.2 Environment Variables]
BASE_URL: http://localhost:8080/api
TOKEN: (향후 JWT 추가)

[12.3 테스트 시나리오]
1. GET Projects: 전체 목록 조회
2. GET Project by ID: 상세 조회
3. POST Project: 새 프로젝트 생성
4. PUT Project: 프로젝트 수정
5. DELETE Project: 프로젝트 삭제
6. Profile CRUD 테스트
7. Experience CRUD 테스트
8. Education CRUD 테스트
9. Skills CRUD 테스트

[12.4 Collection 구조]
📁 Senior Designer Portfolio API
  ├─ 📁 Projects
  │   ├─ GET All Projects
  │   ├─ GET Project by ID
  │   ├─ POST Create Project
  │   ├─ PUT Update Project
  │   └─ DELETE Delete Project
  ├─ 📁 Profile
  │   ├─ GET Profile
  │   └─ PUT Update Profile
  ├─ 📁 Experience
  ├─ 📁 Education
  └─ 📁 Skills''',
          },
        },
      ],
    },
    {
      'category': '테스트 문서',
      'icon': Icons.bug_report,
      'color': AppColors.warning,
      'documents': [
        {
          'title': '1. 테스트 계획서 (Test Plan)',
          'fields': {
            '1. 문서 정보': '''문서명: 테스트 계획서
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025-02-01
작성자: [QA 엔지니어 / 개발자 이름]
승인자: [프로젝트 매니저]''',
            '2. 테스트 개요': '''[2.1 목적]
Senior Designer Portfolio 웹사이트의 품질 보증을 위한 종합 테스트 계획

[2.2 테스트 목표]
• 모든 기능이 요구사항 명세서대로 동작하는지 검증
• 다양한 디바이스 및 브라우저에서 정상 작동 확인
• 성능 기준 (Lighthouse 90+) 충족 검증
• 접근성 표준 (WCAG 2.1 AA) 준수 확인
• 사용자 경험 품질 보장

[2.3 테스트 범위]
포함:
✓ 기능 테스트 (Functional Testing)
✓ 반응형 테스트 (Responsive Testing)
✓ 브라우저 호환성 테스트 (Cross-Browser Testing)
✓ 성능 테스트 (Performance Testing)
✓ 접근성 테스트 (Accessibility Testing)
✓ 사용성 테스트 (Usability Testing)

제외:
✗ 보안 침투 테스트 (향후 계획)
✗ 부하 테스트 (트래픽 규모상 불필요)
✗ 자동화 테스트 (시간 제약)''',
            '3. 테스트 전략': '''[3.1 테스트 레벨]
• Unit Testing: 개별 컴포넌트 단위 테스트 (선택)
• Integration Testing: API 연동 테스트
• System Testing: 전체 시스템 통합 테스트
• Acceptance Testing: 사용자 수용 테스트

[3.2 테스트 유형]
1. 기능 테스트 (Functional)
   - 모든 페이지 기능 동작 확인
   - Admin CRUD 기능 검증
   - 폼 유효성 검사
   - 네비게이션 및 라우팅

2. 비기능 테스트 (Non-Functional)
   - 성능 (Lighthouse)
   - 접근성 (WCAG)
   - 사용성 (Usability)
   - 호환성 (Compatibility)

[3.3 테스트 환경]
브라우저:
• Chrome 120+ (Windows, macOS)
• Safari 17+ (macOS, iOS)
• Edge 120+ (Windows)
• Firefox 120+ (Windows, macOS)

디바이스:
• Mobile: iPhone 13 Pro (375px), Samsung Galaxy S21 (360px)
• Tablet: iPad Pro (1024px)
• Desktop: 1920px × 1080px, 1280px × 720px

운영체제:
• Windows 11
• macOS Sonoma
• iOS 17
• Android 13''',
            '4. 기능 테스트 (Functional Testing)': '''[4.1] 메인 페이지 (Home Page)
테스트 항목:
□ Hero Section 로딩 및 애니메이션
□ About Section 프로필 정보 표시
□ Portfolio Gallery 프로젝트 카드 표시
□ 카테고리 필터링 (All, Brand, Product, Editorial)
□ Skills Section 스킬 카드 표시
□ Resume Section PDF 다운로드 버튼
□ Footer 링크 동작

기대 결과:
• 모든 섹션이 정상적으로 로드됨
• 애니메이션이 부드럽게 실행됨
• 카테고리 필터링이 즉시 반영됨
• PDF 다운로드가 정상 작동함

─────────────────────────────────────

[4.2] 프로젝트 상세 페이지 (Project Detail)
테스트 항목:
□ 프로젝트 ID로 상세 페이지 접근
□ 프로젝트 정보 (제목, 설명, 이미지) 표시
□ 이미지 갤러리 네비게이션
□ 이전/다음 프로젝트 버튼
□ 뒤로가기 버튼
□ 존재하지 않는 ID 접근 시 404 페이지

기대 결과:
• 프로젝트 상세 정보가 정확히 표시됨
• 이미지 갤러리가 정상 작동함
• 네비게이션 버튼이 올바른 페이지로 이동함
• 404 에러 페이지가 적절히 표시됨

─────────────────────────────────────

[4.3] Admin 페이지 - 프로젝트 CRUD
테스트 항목:
□ 프로젝트 목록 조회
□ 새 프로젝트 추가 (모달)
□ 프로젝트 수정 (모달)
□ 프로젝트 삭제 (확인 다이얼로그)
□ 드래그 앤 드롭으로 순서 변경
□ 필수 필드 유효성 검사
□ 이미지 URL 검증

테스트 데이터:
• Title: "Test Project"
• Subtitle: "Test Description"
• Category: "Brand"
• Tags: ["Test", "QA"]

기대 결과:
• CRUD 모든 기능이 정상 작동함
• 유효성 검사가 올바르게 동작함
• 순서 변경이 즉시 반영됨

─────────────────────────────────────

[4.4] Admin 페이지 - 프로필/경력/학력/스킬
테스트 항목:
□ 프로필 정보 수정
□ 경력 추가/수정/삭제
□ 학력 추가/수정/삭제
□ 스킬 추가/수정/삭제
□ 데이터 저장 확인
□ 에러 핸들링

기대 결과:
• 모든 CRUD 기능이 정상 작동함
• 변경사항이 즉시 반영됨
• 에러 메시지가 명확히 표시됨''',
            '5. 반응형 테스트 (Responsive Testing)': '''[5.1] Mobile (< 768px)
테스트 디바이스:
• iPhone 13 Pro (375px × 812px)
• Samsung Galaxy S21 (360px × 800px)

테스트 항목:
□ 1 column 레이아웃 적용
□ 햄버거 메뉴 네비게이션
□ 터치 인터랙션 (버튼 크기 44px × 44px)
□ 스크롤 성능
□ 가로/세로 모드 전환
□ 이미지 로딩 (Lazy Loading)

기대 결과:
• 레이아웃이 모바일에 최적화됨
• 터치 타겟이 충분히 큼
• 스크롤이 부드러움
• 회전 시 레이아웃이 즉시 재조정됨

─────────────────────────────────────

[5.2] Tablet (768px ~ 1023px)
테스트 디바이스:
• iPad Pro (1024px × 1366px)
• Surface Pro (912px × 1368px)

테스트 항목:
□ 2-3 column 레이아웃 적용
□ 네비게이션 메뉴 표시
□ 카드 그리드 레이아웃
□ 여백 및 간격 조정

기대 결과:
• 중간 크기 화면에 최적화된 레이아웃
• 콘텐츠가 적절히 배치됨

─────────────────────────────────────

[5.3] Desktop (≥ 1024px)
테스트 해상도:
• 1280px × 720px (HD)
• 1920px × 1080px (Full HD)
• 2560px × 1440px (2K)

테스트 항목:
□ 12 column grid 레이아웃
□ Full 네비게이션
□ 호버 효과
□ Max-width 1200px 적용

기대 결과:
• 넓은 화면에서 최적의 가독성
• 콘텐츠가 중앙 정렬되고 max-width 제한됨''',
            '6. 브라우저 호환성 테스트': '''[6.1] Chrome (120+)
테스트 항목:
□ 페이지 렌더링
□ CSS Grid/Flexbox
□ JavaScript 동작
□ 애니메이션 성능
□ 개발자 도구 콘솔 에러 확인

─────────────────────────────────────

[6.2] Safari (17+)
테스트 항목:
□ Webkit 렌더링
□ CSS 호환성 (-webkit- prefix)
□ Scroll 성능
□ Font 렌더링
□ iOS Safari 터치 이벤트

알려진 이슈:
• Webkit scroll bounce 효과
• Date picker 스타일 차이

─────────────────────────────────────

[6.3] Edge (120+)
테스트 항목:
□ Chromium 기반 렌더링
□ Windows 특정 폰트 렌더링
□ 호환성 모드 비활성화 확인

─────────────────────────────────────

[6.4] Firefox (120+)
테스트 항목:
□ Gecko 렌더링
□ CSS Grid 레이아웃
□ Flexbox 동작
□ 개발자 도구 경고 확인

알려진 이슈:
• Flexbox min-height 버그 (해결됨)''',
            '7. 성능 테스트 (Performance Testing)': '''[7.1] Lighthouse 성능 측정
목표 점수:
• Performance: 90+ ✓
• Accessibility: 90+ ✓
• Best Practices: 90+ ✓
• SEO: 80+ ✓

측정 환경:
• Chrome DevTools Lighthouse
• Incognito Mode (캐시 없음)
• Desktop & Mobile 모드

테스트 페이지:
□ Home Page
□ Project Detail Page
□ Admin Page

─────────────────────────────────────

[7.2] Core Web Vitals
목표 지표:
• LCP (Largest Contentful Paint): < 2.5s
• FID (First Input Delay): < 100ms
• CLS (Cumulative Layout Shift): < 0.1

측정 도구:
• Chrome DevTools Performance
• PageSpeed Insights

─────────────────────────────────────

[7.3] 로딩 시간
목표:
• First Contentful Paint (FCP): < 1.8s
• Time to Interactive (TTI): < 3.0s
• Total Blocking Time (TBT): < 200ms

최적화 체크리스트:
□ 이미지 최적화 (WebP, Lazy Loading)
□ 코드 스플리팅
□ Minification (CSS, JS)
□ Gzip 압축
□ CDN 사용 (Firebase Hosting)

─────────────────────────────────────

[7.4] 네트워크 성능
테스트 조건:
• Fast 3G: 다운로드 1.6Mbps, 업로드 750Kbps
• Slow 3G: 다운로드 500Kbps, 업로드 500Kbps

측정 항목:
□ 페이지 로드 시간
□ API 응답 시간
□ 이미지 로딩 시간

기대 결과:
• Fast 3G에서 5초 이내 로드
• Slow 3G에서 10초 이내 로드''',
            '8. 접근성 테스트 (Accessibility Testing)': '''[8.1] WCAG 2.1 AA 준수
테스트 도구:
• axe DevTools (Chrome Extension)
• WAVE (Web Accessibility Evaluation Tool)
• Lighthouse Accessibility Audit

테스트 항목:
□ 색상 대비율 4.5:1 이상
□ 키보드 네비게이션 가능
□ 스크린 리더 호환성
□ ARIA 레이블 적용
□ Focus Indicator 명확성
□ 이미지 alt 텍스트
□ 폼 레이블 연결

─────────────────────────────────────

[8.2] 키보드 네비게이션
테스트 시나리오:
1. Tab 키로 모든 인터랙티브 요소 접근
2. Enter/Space로 버튼 활성화
3. Esc로 모달 닫기
4. Arrow 키로 갤러리 네비게이션

기대 결과:
• 마우스 없이 모든 기능 사용 가능
• Focus 순서가 논리적임
• Focus Indicator가 명확히 표시됨

─────────────────────────────────────

[8.3] 스크린 리더
테스트 도구:
• NVDA (Windows)
• VoiceOver (macOS/iOS)
• TalkBack (Android)

테스트 항목:
□ 페이지 제목 읽기
□ 헤딩 계층 구조
□ 링크 및 버튼 설명
□ 이미지 대체 텍스트
□ 폼 레이블 읽기
□ 에러 메시지 알림

기대 결과:
• 모든 콘텐츠가 스크린 리더로 접근 가능
• 의미 있는 순서로 읽힘
• 동적 콘텐츠 변경이 알려짐''',
            '9. 버그 트래킹': '''[9.1] 버그 심각도 분류
Critical (치명적):
• 서비스 중단
• 데이터 손실
• 보안 취약점

Major (주요):
• 핵심 기능 작동 불가
• 많은 사용자에게 영향

Minor (경미):
• UI 깨짐
• 작은 기능 오류

Trivial (사소함):
• 오타
• 디자인 미세 조정

─────────────────────────────────────

[9.2] 버그 보고 템플릿
제목: [페이지명] 간단한 버그 설명

재현 단계:
1. 페이지 접속
2. 버튼 클릭
3. 에러 발생

기대 결과:
• 정상 동작 설명

실제 결과:
• 버그 설명

환경:
• 브라우저: Chrome 120
• OS: Windows 11
• 화면 크기: 1920px

스크린샷:
[첨부]

─────────────────────────────────────

[9.3] 버그 트래킹 시트 예시
| ID | 제목 | 심각도 | 상태 | 담당자 | 발견일 | 해결일 |
|----|------|--------|------|--------|--------|--------|
| 1  | 프로젝트 삭제 버튼 미작동 | Major | Fixed | [이름] | 02/10 | 02/11 |
| 2  | 모바일 네비게이션 깨짐 | Minor | Open | [이름] | 02/12 | - |
| 3  | Resume PDF 다운로드 느림 | Minor | In Progress | [이름] | 02/13 | - |''',
            '10. 테스트 일정': '''[10.1] 테스트 Phase 1 (Week 9)
기간: 2025.03.12 ~ 2025.03.18 (7일)

Day 1-2: 기능 테스트
• 메인 페이지 기능 테스트
• 프로젝트 상세 페이지 테스트

Day 3-4: Admin CRUD 테스트
• 프로젝트 CRUD 테스트
• 프로필/경력/학력/스킬 테스트

Day 5-6: 반응형 & 브라우저 테스트
• Mobile/Tablet/Desktop 테스트
• Chrome/Safari/Edge/Firefox 테스트

Day 7: 버그 수정
• Critical/Major 버그 우선 수정

─────────────────────────────────────

[10.2] 테스트 Phase 2 (Week 10)
기간: 2025.03.19 ~ 2025.03.25 (7일)

Day 1-2: 성능 테스트
• Lighthouse 측정
• Core Web Vitals 측정
• 네트워크 성능 테스트

Day 3-4: 접근성 테스트
• WCAG 2.1 AA 검증
• 키보드 네비게이션
• 스크린 리더 테스트

Day 5: 사용성 테스트
• 실제 사용자 테스트 (3-5명)
• 피드백 수집

Day 6-7: 최종 버그 수정
• Minor/Trivial 버그 수정
• 회귀 테스트 (Regression Testing)''',
            '11. 테스트 체크리스트': '''[11.1] 배포 전 최종 체크리스트
기능 테스트:
□ 모든 페이지 정상 로드
□ 네비게이션 동작
□ 폼 유효성 검사
□ CRUD 기능 정상

반응형:
□ Mobile (375px)
□ Tablet (768px)
□ Desktop (1280px, 1920px)

브라우저:
□ Chrome
□ Safari
□ Edge
□ Firefox

성능:
□ Lighthouse 90+ 달성
□ LCP < 2.5s
□ FID < 100ms
□ CLS < 0.1

접근성:
□ WCAG 2.1 AA 준수
□ 키보드 네비게이션
□ 스크린 리더 호환

보안:
□ HTTPS 적용
□ XSS 방어
□ Input Validation

기타:
□ 콘솔 에러 없음
□ 404 페이지 동작
□ 로딩 인디케이터
□ 에러 메시지 명확''',
            '12. 테스트 결과 보고서 템플릿': '''[12.1] 테스트 요약
테스트 기간: 2025.03.12 ~ 2025.03.25
테스트 담당: [QA 엔지니어 이름]

전체 테스트 케이스: 120개
통과: 115개 (95.8%)
실패: 5개 (4.2%)

─────────────────────────────────────

[12.2] 테스트 결과 상세
기능 테스트:
✓ 통과: 48/50 (96%)
✗ 실패: 2개 (Admin 프로젝트 순서 변경, Resume PDF 다운로드)

반응형 테스트:
✓ 통과: 30/30 (100%)

브라우저 호환성:
✓ 통과: 18/20 (90%)
✗ 실패: 2개 (Safari iOS 스크롤 이슈, Firefox 폰트 렌더링)

성능 테스트:
✓ Lighthouse 점수:
  - Performance: 94
  - Accessibility: 96
  - Best Practices: 92
  - SEO: 88

접근성 테스트:
✓ 통과: 19/20 (95%)
✗ 실패: 1개 (일부 이미지 alt 누락)

─────────────────────────────────────

[12.3] 발견된 버그
Critical: 0개
Major: 2개
Minor: 5개
Trivial: 3개

─────────────────────────────────────

[12.4] 권장 사항
1. Admin 프로젝트 순서 변경 버그 수정 (Major)
2. Safari iOS 스크롤 성능 최적화 (Major)
3. 모든 이미지에 alt 텍스트 추가 (Minor)
4. Firefox 폰트 렌더링 개선 (Minor)
5. Resume PDF 생성 속도 개선 (Minor)

─────────────────────────────────────

[12.5] 결론
전체적으로 높은 품질 수준 달성.
Major 버그 2개 수정 후 배포 가능.
성능 및 접근성 목표 달성.''',
          },
        },
      ],
    },
    {
      'category': '배포 문서',
      'icon': Icons.cloud_upload,
      'color': AppColors.accentCyan,
      'documents': [
        {
          'title': '1. 배포 가이드 (Deployment Guide)',
          'fields': {
            '1. 문서 정보': '''문서명: 배포 가이드
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025-03-01
작성자: [DevOps / 개발자 이름]
대상: 개발자, DevOps 엔지니어''',
            '2. 배포 개요': '''[2.1 목적]
Senior Designer Portfolio 프로젝트를 프로덕션 환경에 안전하게 배포하기 위한 가이드

[2.2 배포 환경]
Frontend (Flutter Web):
• 호스팅: Firebase Hosting
• URL: https://your-project.web.app
• CDN: Firebase CDN (자동)
• SSL: 자동 제공

Backend (Dart Shelf):
• 호스팅: Railway (또는 Render)
• URL: https://your-api.railway.app
• Database: JSON 파일 (db.json)
• SSL: 자동 제공

[2.3 배포 전략]
• Blue-Green Deployment (무중단 배포)
• CI/CD 자동화 (GitHub Actions)
• 모니터링 & 롤백 준비''',
            '3. 프론트엔드 배포 (Firebase Hosting)': '''[3.1] 사전 준비
요구사항:
□ Flutter SDK 설치
□ Firebase CLI 설치
□ Firebase 프로젝트 생성
□ Google 계정

설치 명령:
npm install -g firebase-tools
firebase login

─────────────────────────────────────

[3.2] Flutter Web 빌드
빌드 명령:
flutter build web --release

빌드 옵션:
--release: 프로덕션 최적화 빌드
--web-renderer html: HTML 렌더러 (호환성 우선)
--web-renderer canvaskit: CanvasKit 렌더러 (성능 우선)

권장:
flutter build web --release --web-renderer canvaskit

빌드 결과:
📁 build/web/
  ├─ index.html
  ├─ main.dart.js
  ├─ flutter.js
  ├─ assets/
  └─ icons/

─────────────────────────────────────

[3.3] Firebase 프로젝트 초기화
초기화 명령:
firebase init

선택 항목:
? Which Firebase features?
  ✓ Hosting

? Project Setup
  ✓ Use existing project
  ✓ Select: your-project-id

? Hosting Setup
  ✓ Public directory: build/web
  ✓ Configure as SPA: Yes
  ✓ Set up automatic builds: No
  ✓ Overwrite index.html: No

결과:
생성 파일: firebase.json, .firebaserc

─────────────────────────────────────

[3.4] firebase.json 설정
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css|woff2|woff|ttf)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "**/*.@(jpg|jpeg|gif|png|webp|svg)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=86400"
          }
        ]
      }
    ]
  }
}

─────────────────────────────────────

[3.5] 배포 실행
배포 명령:
firebase deploy --only hosting

배포 과정:
✓ Preparing files...
✓ Uploading files...
✓ Finalizing deployment...
✓ Deploy complete!

배포 URL:
Hosting URL: https://your-project.web.app

테스트:
1. 배포 URL 접속
2. 모든 페이지 동작 확인
3. 이미지 로딩 확인
4. API 연동 확인

─────────────────────────────────────

[3.6] 커스텀 도메인 연결
Firebase Console 접속:
1. Hosting → 도메인 추가
2. 도메인 입력: yourportfolio.com
3. DNS 설정:
   - A 레코드: 151.101.1.195, 151.101.65.195
   - TXT 레코드: firebase verification
4. SSL 인증서 자동 발급 (최대 24시간)

확인:
https://yourportfolio.com 접속''',
            '4. 백엔드 배포 (Railway)': '''[4.1] Railway 계정 설정
1. Railway 가입: https://railway.app
2. GitHub 연동
3. 새 프로젝트 생성

─────────────────────────────────────

[4.2] 프로젝트 구조 준비
필수 파일:
📁 server/
  ├─ bin/server.dart        # 메인 서버 파일
  ├─ data/db.json          # 데이터베이스
  ├─ pubspec.yaml          # 의존성
  ├─ Dockerfile            # Docker 설정
  └─ railway.json          # Railway 설정

─────────────────────────────────────

[4.3] Dockerfile 작성
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/data/ /app/data/

EXPOSE 8080
CMD ["/app/bin/server"]

─────────────────────────────────────

[4.4] railway.json 설정
{
  "build": {
    "builder": "DOCKERFILE"
  },
  "deploy": {
    "startCommand": "/app/bin/server",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}

─────────────────────────────────────

[4.5] 환경 변수 설정
Railway Dashboard → Variables:
PORT=8080
CORS_ORIGIN=https://your-project.web.app
DATABASE_PATH=/app/data/db.json

─────────────────────────────────────

[4.6] 배포 실행
방법 1: GitHub 연동 (권장)
1. Railway에서 GitHub 저장소 연결
2. server/ 디렉토리 지정
3. 자동 배포 활성화
4. Push 시 자동 배포

방법 2: Railway CLI
railway login
railway link
railway up

배포 URL:
https://your-api.railway.app

테스트:
curl https://your-api.railway.app/api/projects

─────────────────────────────────────

[4.7] 데이터베이스 마이그레이션
초기 데이터 업로드:
1. Railway Dashboard → Data
2. db.json 업로드
3. 서버 재시작

백업:
railway run "cat /app/data/db.json" > backup.json''',
            '5. CI/CD 설정 (GitHub Actions)': '''[5.1] GitHub Actions 워크플로우
파일 경로: .github/workflows/deploy.yml

name: Deploy to Production

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build web
        run: flutter build web --release

      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '\${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '\${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: your-project-id

─────────────────────────────────────

[5.2] Secrets 설정
GitHub Repository → Settings → Secrets:

FIREBASE_SERVICE_ACCOUNT:
1. Firebase Console → 프로젝트 설정
2. 서비스 계정 → 새 비공개 키 생성
3. JSON 파일 내용 복사
4. GitHub Secrets에 추가

RAILWAY_TOKEN (백엔드 자동 배포):
1. Railway Dashboard → Account → Tokens
2. 새 토큰 생성
3. GitHub Secrets에 추가

─────────────────────────────────────

[5.3] 배포 자동화 흐름
1. 개발자가 main 브랜치에 Push
2. GitHub Actions 트리거
3. 테스트 실행 (flutter test)
4. 빌드 실행 (flutter build web)
5. Firebase에 자동 배포
6. Slack 알림 (선택)

성공 시:
✓ Deployed to https://your-project.web.app

실패 시:
✗ Deployment failed - check logs''',
            '6. 성능 최적화': '''[6.1] 이미지 최적화
사전 처리:
• PNG → WebP 변환
• JPEG 압축 (품질 80-85%)
• 이미지 크기 조정 (max 1920px)

도구:
# ImageMagick
convert input.png -quality 85 output.webp

# 일괄 변환
for img in *.png; do
  convert "\$img" -quality 85 "\${img%.png}.webp"
done

─────────────────────────────────────

[6.2] 코드 스플리팅
pubspec.yaml 설정:
flutter:
  deferred-components:
    - name: admin
      libraries:
        - package:portfolio/features/admin

빌드 옵션:
flutter build web --split-debug-info=build/debug

결과:
• main.dart.js 크기 감소
• 초기 로딩 속도 향상

─────────────────────────────────────

[6.3] Gzip 압축
Firebase Hosting은 자동 Gzip 압축 제공
확인:
curl -H "Accept-Encoding: gzip" -I https://your-project.web.app

Response Headers:
Content-Encoding: gzip

─────────────────────────────────────

[6.4] CDN 캐싱
Firebase Hosting CDN:
• 전 세계 엣지 로케이션
• 자동 캐시 관리
• Cache-Control 헤더 설정 (firebase.json)

캐시 정책:
• HTML: 1시간 (3600s)
• JS/CSS: 1년 (31536000s)
• 이미지: 1일 (86400s)

캐시 무효화:
firebase hosting:channel:deploy preview --expires 1h''',
            '7. 모니터링 & 로깅': '''[7.1] Google Analytics 설정
Firebase Console → Analytics:
1. Google Analytics 활성화
2. 측정 ID 복사: G-XXXXXXXXXX

index.html에 추가:
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>

추적 지표:
• 페이지 뷰
• 사용자 세션
• 이벤트 (버튼 클릭, 다운로드)

─────────────────────────────────────

[7.2] Sentry 에러 모니터링
설치:
flutter pub add sentry_flutter

main.dart 설정:
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://xxx@sentry.io/xxx';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

에러 자동 캡처:
• Unhandled exceptions
• HTTP errors
• Widget build errors

Sentry Dashboard:
• 에러 알림
• 스택 트레이스
• 사용자 영향 분석

─────────────────────────────────────

[7.3] Lighthouse CI
설치:
npm install -g @lhci/cli

설정 파일: lighthouserc.js
module.exports = {
  ci: {
    collect: {
      url: ['https://your-project.web.app'],
      numberOfRuns: 3,
    },
    assert: {
      preset: 'lighthouse:recommended',
      assertions: {
        'categories:performance': ['error', {minScore: 0.9}],
        'categories:accessibility': ['error', {minScore: 0.9}],
      },
    },
  },
};

실행:
lhci autorun

결과:
Performance: 94 ✓
Accessibility: 96 ✓
Best Practices: 92 ✓

─────────────────────────────────────

[7.4] Uptime 모니터링
도구: UptimeRobot (무료)
1. UptimeRobot 가입
2. Monitor 추가:
   - Type: HTTP(s)
   - URL: https://your-project.web.app
   - Interval: 5분
3. 알림 설정 (Email/Slack)

모니터링 항목:
• 서버 다운타임
• 응답 시간
• SSL 인증서 만료''',
            '8. 보안 설정': '''[8.1] HTTPS 강제
Firebase Hosting은 기본 HTTPS 제공
확인:
https://your-project.web.app (✓)
http://your-project.web.app → 자동 리다이렉트

─────────────────────────────────────

[8.2] CORS 설정
백엔드 server.dart:
final handler = Pipeline()
    .addMiddleware(
      corsHeaders(headers: {
        'Access-Control-Allow-Origin': 'https://your-project.web.app',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      }),
    )
    .addHandler(router);

프로덕션:
• 특정 도메인만 허용
• Wildcard (*) 금지

─────────────────────────────────────

[8.3] 환경 변수 보안
Railway 환경 변수:
✓ DATABASE_PATH (안전)
✓ API_KEY (안전)
✗ Git에 커밋하지 말 것

.gitignore 추가:
.env
*.env
secrets.json

─────────────────────────────────────

[8.4] Firebase Security Rules
Firestore Rules (향후 사용 시):
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /projects/{projectId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}

테스트:
firebase emulators:start --only firestore''',
            '9. 롤백 전략': '''[9.1] Firebase Hosting 롤백
이전 버전 목록 보기:
firebase hosting:channel:list

특정 버전으로 롤백:
firebase hosting:rollback

또는 Firebase Console:
1. Hosting → Release history
2. 이전 버전 선택
3. Rollback 클릭

롤백 시간: ~1분

─────────────────────────────────────

[9.2] Railway 롤백
Railway Dashboard:
1. Deployments → 이전 배포 선택
2. Redeploy 클릭
3. 확인

또는 Git revert:
git revert <commit-hash>
git push origin main

자동 재배포 트리거

─────────────────────────────────────

[9.3] 데이터베이스 백업
자동 백업 스크립트:
#!/bin/bash
DATE=\$(date +%Y%m%d_%H%M%S)
railway run "cat /app/data/db.json" > backups/db_\$DATE.json

cron 설정 (매일 오전 3시):
0 3 * * * /path/to/backup.sh

복원:
railway run "cat > /app/data/db.json" < backups/db_20250301.json''',
            '10. 배포 체크리스트': '''[10.1] 배포 전 체크리스트
코드:
□ 모든 테스트 통과
□ 린트 오류 없음
□ 콘솔 에러 없음
□ TODO 주석 제거
□ 디버그 코드 제거

빌드:
□ flutter build web --release 성공
□ 빌드 크기 확인 (< 5MB)
□ 이미지 최적화 완료

환경 설정:
□ API URL 프로덕션으로 변경
□ 환경 변수 설정 완료
□ CORS 설정 확인

보안:
□ HTTPS 적용
□ 민감 정보 제거
□ .env 파일 .gitignore

성능:
□ Lighthouse 90+ 달성
□ 이미지 WebP 변환
□ 코드 스플리팅 적용

─────────────────────────────────────

[10.2] 배포 후 체크리스트
기능 테스트:
□ 모든 페이지 로드 확인
□ Admin CRUD 동작 확인
□ API 연동 확인
□ 이미지 로딩 확인

성능:
□ 로딩 속도 < 3초
□ Lighthouse 점수 확인
□ 모바일 반응형 확인

모니터링:
□ Google Analytics 데이터 수집
□ Sentry 에러 없음
□ Uptime 모니터링 활성화

기타:
□ 커스텀 도메인 연결
□ SSL 인증서 발급
□ 팀에 배포 알림''',
            '11. 트러블슈팅': '''[11.1] 일반적인 문제
문제: Firebase 배포 실패
원인: firebase.json 설정 오류
해결: public 경로 확인 (build/web)

문제: API CORS 에러
원인: CORS 헤더 누락
해결: server.dart에 corsHeaders 추가

문제: 이미지 로딩 실패
원인: 잘못된 이미지 URL
해결: 절대 경로 사용, Railway에 이미지 업로드

문제: Railway 서버 다운
원인: 메모리 부족
해결: Railway Plan 업그레이드

문제: 빌드 크기 너무 큼
원인: 최적화 미적용
해결: --release 플래그, 코드 스플리팅

─────────────────────────────────────

[11.2] 긴급 대응
서비스 다운:
1. Uptime 알림 확인
2. Railway/Firebase 상태 확인
3. 이전 버전으로 롤백
4. 팀에 알림

성능 저하:
1. Lighthouse 재측정
2. 서버 로그 확인
3. CDN 캐시 무효화
4. 이미지 최적화 재확인

보안 이슈:
1. 즉시 서비스 중단
2. 취약점 패치
3. 환경 변수 재설정
4. 재배포''',
            '12. 배포 완료 보고서 템플릿': '''[12.1] 배포 정보
배포 일시: 2025.03.30 14:30 KST
배포자: [개발자 이름]
버전: v1.0.0
Git Commit: a1b2c3d

[12.2] 배포 환경
Frontend:
• URL: https://your-project.web.app
• 호스팅: Firebase Hosting
• CDN: Firebase CDN
• SSL: 자동 (Let's Encrypt)

Backend:
• URL: https://your-api.railway.app
• 호스팅: Railway
• Database: JSON (db.json)
• SSL: 자동

[12.3] 배포 결과
빌드:
✓ Flutter Web 빌드 성공
✓ 빌드 크기: 3.2MB
✓ 빌드 시간: 2분 30초

배포:
✓ Firebase 배포 성공
✓ Railway 배포 성공
✓ 배포 시간: 5분

테스트:
✓ 기능 테스트 통과
✓ 성능 테스트 통과
✓ 보안 점검 완료

성능 지표:
• Lighthouse Performance: 94
• Lighthouse Accessibility: 96
• 페이지 로드 시간: 2.1초
• API 응답 시간: 150ms

[12.4] 이슈 및 해결
이슈 1: Safari 스크롤 성능
해결: -webkit-overflow-scrolling 추가

이슈 2: 이미지 로딩 느림
해결: WebP 변환 및 Lazy Loading 적용

[12.5] 다음 단계
□ Google Analytics 데이터 모니터링
□ 사용자 피드백 수집
□ 성능 지표 추적
□ 버그 수정 준비

[12.6] 연락처
개발자: [이메일]
DevOps: [이메일]
긴급 연락: [전화번호]''',
          },
        },
      ],
    },
    {
      'category': 'PM 문서',
      'icon': Icons.psychology,
      'color': AppColors.primaryBlue,
      'documents': [
        {
          'title': '1. 프로젝트 회고 (Project Retrospective)',
          'fields': {
            '1. 문서 정보': '''문서명: 프로젝트 회고
프로젝트: Senior Designer Portfolio
버전: 1.0
작성일: 2025.04.10 (프로젝트 완료 후)
작성자: [프로젝트 매니저 / 개발자 이름]
참여자: [팀원 전체]''',
            '2. 프로젝트 개요': '''[2.1] 프로젝트 정보
프로젝트명: Senior Designer Portfolio
기간: 2025.01.15 ~ 2025.04.07 (12주)
참여 인원: 1인 (기획 / 디자인 / 개발)
최종 결과: 성공적 완료 및 배포

[2.2] 프로젝트 목표
비즈니스 목표:
✓ 대기업 UX 디자이너 포지션 지원용 포트폴리오 구축
✓ 디자인 + 개발 통합 역량 증명
✓ 프로젝트 수행 능력 증명

기술적 목표:
✓ Flutter Web 기반 반응형 포트폴리오 개발
✓ Atomic Design System 구축
✓ REST API 백엔드 개발
✓ Firebase Hosting 배포

성과 지표:
✓ Lighthouse 성능 점수: 90점 이상 달성
✓ 반응형 지원: Mobile / Tablet / Desktop 완료
✓ 접근성: WCAG 2.1 AA 준수 완료
✓ 로딩 속도: 3초 이내 달성

[2.3] 최종 성과
✅ 목표 100% 달성
✅ 일정 준수 (12주)
✅ 예산 범위 내 완료
✅ 품질 기준 초과 달성''',
            '3. 타임라인 & 마일스톤': '''[3.1] 전체 타임라인
Phase 1: 기획 & 디자인 (Week 1-2)
• 계획: 2주
• 실제: 2주
• 상태: ✓ 완료

Phase 2: 개발 환경 구축 (Week 3)
• 계획: 1주
• 실제: 1주
• 상태: ✓ 완료

Phase 3: 프론트엔드 개발 (Week 4-7)
• 계획: 4주
• 실제: 4.5주
• 상태: ✓ 완료 (0.5주 지연)
• 지연 원인: 디자인 시스템 컴포넌트 추가 요구

Phase 4: 백엔드 개발 (Week 8)
• 계획: 1주
• 실제: 0.5주
• 상태: ✓ 완료 (0.5주 단축)
• 단축 이유: JSON DB 사용으로 복잡도 감소

Phase 5: 테스트 & QA (Week 9-10)
• 계획: 2주
• 실제: 2주
• 상태: ✓ 완료

Phase 6: 배포 & 런칭 (Week 11-12)
• 계획: 2주
• 실제: 1.5주
• 상태: ✓ 완료 (0.5주 단축)
• 단축 이유: CI/CD 자동화로 배포 프로세스 간소화

[3.2] 주요 마일스톤
M1: 디자인 완료 (Week 2) - ✓ 달성
M2: 개발 환경 구축 완료 (Week 3) - ✓ 달성
M3: 프론트엔드 개발 완료 (Week 7) - ✓ 달성 (0.5주 지연)
M4: 백엔드 개발 완료 (Week 8) - ✓ 달성
M5: QA 완료 (Week 10) - ✓ 달성
M6: 공식 런칭 (Week 12) - ✓ 달성

전체 일정 준수율: 95% (12주 계획, 12주 완료)''',
            '4. 성과 분석': '''[4.1] 정량적 성과
기술 성과:
• Lighthouse Performance: 94점 (목표 90+ ✓)
• Lighthouse Accessibility: 96점 (목표 90+ ✓)
• Lighthouse Best Practices: 92점 (목표 90+ ✓)
• Lighthouse SEO: 88점 (목표 80+ ✓)
• 페이지 로드 시간: 2.1초 (목표 3초 이내 ✓)
• 반응형 지원: 3개 디바이스 (Mobile/Tablet/Desktop ✓)
• 접근성 준수: WCAG 2.1 AA 100% ✓

개발 성과:
• 총 코드 라인: ~8,000 lines
• 컴포넌트 개수: 45개 (Atoms 15, Molecules 18, Organisms 12)
• API 엔드포인트: 15개
• Git 커밋: 120+ commits
• 테스트 케이스: 120개 (통과율 95.8%)

비용 성과:
• 총 비용: \$1/month (목표 범위 내 ✓)
• Firebase Hosting: \$0 (무료 플랜)
• Railway: \$0 (무료 플랜)
• 도메인: \$10/year

[4.2] 정성적 성과
학습 성과:
✓ Flutter Web 프레임워크 마스터
✓ Atomic Design System 실무 적용
✓ REST API 설계 및 구현
✓ CI/CD 파이프라인 구축
✓ 성능 최적화 기법 습득

프로세스 성과:
✓ 체계적인 프로젝트 수행 경험
✓ 요구사항 분석 → 설계 → 개발 → 테스트 → 배포 전체 사이클 경험
✓ 문서화 습관 확립
✓ Git 버전 관리 체계 확립

포트폴리오 성과:
✓ 대기업 지원용 고품질 포트폴리오 완성
✓ 디자인 + 개발 역량 증명
✓ 실제 배포된 서비스 구축 경험''',
            '5. Keep (잘한 점)': '''[5.1] 프로세스
✅ 체계적인 기획
• WBS 작성으로 명확한 일정 계획
• 요구사항 명세서(SRS)로 범위 명확화
• 단계별 산출물 정의

✅ 디자인 시스템 우선 구축
• Atomic Design 방법론 적용
• 재사용 가능한 컴포넌트 설계
• 일관된 UI/UX 유지

✅ Git 버전 관리
• Feature 브랜치 전략 사용
• 의미 있는 커밋 메시지 작성
• 코드 리뷰 및 머지 프로세스

✅ 문서화
• README.md 상세 작성
• API 명세서 작성
• 코드 주석 충실

[5.2] 기술
✅ 성능 최적화
• 이미지 WebP 변환 및 Lazy Loading
• 코드 스플리팅 적용
• CDN 캐싱 활용

✅ 접근성 고려
• WCAG 2.1 AA 준수
• 키보드 네비게이션 지원
• 스크린 리더 호환성

✅ 반응형 디자인
• Mobile First 접근
• Breakpoint 체계적 관리
• 터치 최적화

✅ CI/CD 자동화
• GitHub Actions 설정
• 자동 테스트 및 배포
• 배포 시간 단축 (수동 30분 → 자동 5분)

[5.3] 협업 (1인 프로젝트)
✅ 자기 관리
• 주간 계획 수립 및 회고
• 진행 상황 추적 (GitHub Projects)
• 일정 준수 노력''',
            '6. Problem (문제점)': '''[6.1] 기술적 문제
❌ Flutter Web 성능 이슈
• 초기 로딩 시 JS 번들 크기 큼 (해결: 코드 스플리팅)
• Canvas 렌더링 성능 (해결: CanvasKit 사용)

❌ Safari 브라우저 호환성
• iOS Safari 스크롤 성능 저하 (해결: -webkit-overflow-scrolling)
• Date picker 스타일 불일치 (해결: 커스텀 디자인)

❌ 이미지 최적화 미흡
• 초기 PNG 사용으로 용량 큼 (해결: WebP 변환)
• Lazy Loading 미적용 (해결: 추가 구현)

[6.2] 프로세스 문제
❌ 초기 요구사항 변경
• 디자인 시스템 컴포넌트 추가 (Admin 페이지 확장)
• 해결: Agile 방식으로 유연하게 대응

❌ 테스트 자동화 부족
• 수동 테스트 위주로 시간 소요
• 해결: 주요 기능만 자동 테스트 작성 (향후 개선)

❌ 일정 버퍼 부족
• Phase 3에서 0.5주 지연
• 해결: Phase 4, 6에서 시간 절약으로 만회

[6.3] 리소스 문제
❌ 1인 개발의 한계
• 모든 역할 수행으로 피로도 증가
• 코드 리뷰 없음 (해결: 자체 리뷰 프로세스 확립)

❌ 무료 플랜 제한
• Firebase/Railway 무료 플랜 제약
• 해결: 트래픽 모니터링, 필요 시 유료 전환 계획''',
            '7. Try (시도할 점)': '''[7.1] 기술 개선
🔧 테스트 자동화 강화
• Unit Test 커버리지 80% 목표
• E2E Test 추가 (Playwright)
• CI/CD에 자동 테스트 통합

🔧 성능 추가 최적화
• Service Worker 적용
• PWA 기능 추가
• 이미지 CDN 최적화

🔧 모니터링 강화
• Real User Monitoring (RUM)
• Error Tracking 개선
• Performance 지표 추적

🔧 보안 강화
• JWT 인증 추가
• Rate Limiting 구현
• Security Headers 설정

[7.2] 프로세스 개선
🔧 문서화 자동화
• API 문서 자동 생성
• Changelog 자동 생성
• 버전 관리 체계화

🔧 코드 품질 관리
• ESLint/Prettier 규칙 강화
• Code Review 체크리스트
• 정적 분석 도구 활용

🔧 배포 프로세스 개선
• Blue-Green Deployment
• Canary Release
• 롤백 자동화

[7.3] 학습 및 성장
🔧 기술 스택 확장
• TypeScript 학습
• GraphQL 학습
• Microservices 아키텍처 학습

🔧 협업 도구 학습
• Jira/Confluence
• Slack 통합
• Notion 프로젝트 관리

🔧 디자인 역량 강화
• Figma Advanced 기능
• 디자인 시스템 확장
• UX Writing 학습''',
            '8. 주요 결정 사항': '''[8.1] 기술 스택 결정
결정: Flutter Web 선택
이유:
• 크로스플랫폼 지원
• 고성능 애니메이션
• Dart 언어 통일 (프론트엔드 + 백엔드)
• 빠른 개발 속도

대안: React / Vue
선택 근거: 포트폴리오 차별화 + 학습 목표

─────────────────────────────────────

결정: JSON 파일 DB 사용
이유:
• 간단한 데이터 구조
• 빠른 개발 속도
• 무료 호스팅 가능
• 백업 및 복원 용이

대안: Firebase Firestore, PostgreSQL
선택 근거: 프로젝트 규모에 적합

─────────────────────────────────────

결정: Atomic Design 방법론
이유:
• 체계적인 컴포넌트 관리
• 재사용성 극대화
• 확장 가능한 구조
• 디자인 시스템 구축 경험

대안: BEM, SMACSS
선택 근거: 컴포넌트 기반 프레임워크에 최적

[8.2] 프로세스 결정
결정: Feature 브랜치 전략
이유:
• 안정적인 main 브랜치 유지
• 기능별 독립적 개발
• 코드 리뷰 용이

─────────────────────────────────────

결정: CI/CD 자동화
이유:
• 배포 시간 단축
• 휴먼 에러 방지
• 일관된 배포 프로세스

─────────────────────────────────────

결정: Lighthouse 90+ 목표
이유:
• 업계 표준 품질 기준
• 사용자 경험 보장
• 포트폴리오 경쟁력''',
            '9. 학습 내용': '''[9.1] 기술 학습
Flutter & Dart:
✓ Flutter Web 아키텍처 이해
✓ Riverpod 상태 관리
✓ go_router 네비게이션
✓ 반응형 레이아웃 구현
✓ 애니메이션 및 인터랙션

백엔드 개발:
✓ REST API 설계 원칙
✓ Dart Shelf 프레임워크
✓ CORS 설정 및 보안
✓ JSON 데이터 관리

DevOps:
✓ Firebase Hosting 배포
✓ Railway 배포
✓ GitHub Actions CI/CD
✓ Docker 컨테이너화

성능 최적화:
✓ Lighthouse 성능 측정
✓ 이미지 최적화 (WebP, Lazy Loading)
✓ 코드 스플리팅
✓ CDN 캐싱 전략

접근성:
✓ WCAG 2.1 AA 가이드라인
✓ 키보드 네비게이션
✓ 스크린 리더 호환성
✓ 색상 대비율

[9.2] 프로세스 학습
프로젝트 관리:
✓ WBS (Work Breakdown Structure)
✓ 요구사항 명세서 (SRS)
✓ 테스트 계획서
✓ 배포 가이드

디자인 프로세스:
✓ 정보 구조 설계 (IA)
✓ 와이어프레임 작성
✓ Atomic Design System
✓ Figma 협업

품질 관리:
✓ 테스트 전략 수립
✓ 버그 트래킹
✓ 코드 리뷰 프로세스
✓ 성능 모니터링

[9.3] 소프트 스킬
자기 관리:
✓ 시간 관리 및 우선순위 설정
✓ 목표 설정 및 추적
✓ 자기 주도 학습

문제 해결:
✓ 체계적 디버깅
✓ 대안 탐색 및 비교
✓ 근본 원인 분석

커뮤니케이션:
✓ 기술 문서 작성
✓ 명확한 커밋 메시지
✓ README 작성''',
            '10. 위험 관리': '''[10.1] 발생한 위험
위험 1: Phase 3 일정 지연 (0.5주)
영향도: 중간
대응:
• Phase 4, 6에서 시간 절약
• 우선순위 재조정
• 일일 진행 상황 추적 강화
결과: 전체 일정 준수

─────────────────────────────────────

위험 2: Safari 브라우저 호환성 이슈
영향도: 중간
대응:
• 크로스 브라우저 테스트 강화
• -webkit- prefix 추가
• 커스텀 디자인 적용
결과: 호환성 문제 해결

─────────────────────────────────────

위험 3: 성능 기준 미달성 우려
영향도: 높음
대응:
• 이미지 WebP 변환
• 코드 스플리팅 적용
• Lazy Loading 구현
결과: Lighthouse 94점 달성

[10.2] 완화된 위험
위험: 무료 플랜 제한
완화책: 트래픽 모니터링, 유료 플랜 전환 준비

위험: 1인 개발 피로도
완화책: 주간 계획 및 휴식 스케줄 확립

위험: 기술 스택 변경 가능성
완화책: 모듈화 설계로 유연성 확보''',
            '11. 다음 단계': '''[11.1] 단기 계획 (1-3개월)
□ 포트폴리오 활용
• 대기업 지원 (삼성, 네이버, 카카오 등)
• 이력서에 프로젝트 추가
• GitHub README 개선

□ 기능 개선
• 다크모드 / 라이트모드 토글
• 다국어 지원 (한국어 / 영어)
• 프로젝트 검색 기능

□ 성능 최적화
• Service Worker 적용
• PWA 기능 추가
• 이미지 CDN 최적화

[11.2] 중기 계획 (3-6개월)
□ 기술 스택 확장
• TypeScript 마이그레이션
• GraphQL API 추가
• 테스트 자동화 강화

□ 포트폴리오 확장
• 케이스 스터디 추가
• 블로그 기능 추가
• 사용자 피드백 수집

□ 커뮤니티 활동
• 오픈소스 기여
• 기술 블로그 작성
• 세미나 발표

[11.3] 장기 계획 (6-12개월)
□ 취업 성공
• 대기업 UX 디자이너 합격
• 포트폴리오 지속 업데이트
• 네트워킹 강화

□ 기술 성장
• 새로운 프레임워크 학습
• 아키텍처 패턴 학습
• 멘토링 및 커뮤니티 기여

□ 개인 브랜딩
• 기술 블로그 운영
• 오픈소스 프로젝트
• 컨퍼런스 발표''',
            '12. 회고 요약': '''[12.1] 핵심 성과
✅ 12주 만에 완성도 높은 포트폴리오 완성
✅ Lighthouse 90+ 달성 (Performance 94, Accessibility 96)
✅ 실제 배포 및 운영 경험 획득
✅ 디자인 + 개발 통합 역량 증명
✅ 체계적인 프로젝트 수행 경험

[12.2] 주요 학습
💡 Flutter Web 프레임워크 마스터
💡 Atomic Design System 실무 적용
💡 REST API 설계 및 구현
💡 CI/CD 파이프라인 구축
💡 성능 최적화 및 접근성 준수

[12.3] 개선 영역
🔧 테스트 자동화 강화
🔧 코드 리뷰 프로세스 개선
🔧 문서화 자동화
🔧 모니터링 및 보안 강화

[12.4] 다음 목표
🎯 대기업 UX 디자이너 취업
🎯 포트폴리오 지속 개선
🎯 기술 블로그 운영
🎯 오픈소스 기여

[12.5] 소감
이번 프로젝트를 통해 디자이너에서 풀스택 개발자로 성장하는 계기가 되었습니다. 체계적인 프로세스와 높은 품질 기준을 경험하며, 대기업에서 요구하는 역량을 갖출 수 있었습니다.

특히 성능 최적화와 접근성을 고려한 개발 경험은 사용자 중심 사고를 확립하는 데 큰 도움이 되었습니다. 앞으로도 지속적으로 학습하고 개선하며, 더 나은 제품을 만들어가겠습니다.

[12.6] 감사 인사
• Stack Overflow 커뮤니티
• Flutter 공식 문서 팀
• GitHub 오픈소스 기여자들
• 피드백을 주신 모든 분들

──────────────────────────────────────

작성일: 2025.04.10
작성자: [프로젝트 매니저 / 개발자 이름]
버전: 1.0''',
          },
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = _templates[_selectedIndex];
    final documents = selectedTemplate['documents'] as List<Map<String, dynamic>>;

    return Container(
      color: AppColors.deepSpace,
      child: Row(
        children: [
          // 왼쪽 사이드바
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              border: Border(
                right: BorderSide(
                  color: AppColors.lightGray300.withOpacity(0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '프로젝트 문서 템플릿',
                        style: AppTypography.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '현업에서 사용하는 실제 문서 양식',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.lightGray300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.lightGray300, height: 1),

                // 카테고리 리스트
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _templates.length,
                    itemBuilder: (context, index) {
                      final template = _templates[index];
                      final isSelected = _selectedIndex == index;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (template['color'] as Color).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: template['color'] as Color,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: ListTile(
                          leading: Icon(
                            template['icon'] as IconData,
                            color: isSelected
                                ? (template['color'] as Color)
                                : AppColors.lightGray300,
                          ),
                          title: Text(
                            template['category'] as String,
                            style: AppTypography.bodyLarge.copyWith(
                              color: isSelected ? Colors.white : AppColors.lightGray300,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // 하단 정보
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.lightGray300.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '사용 방법',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. 카테고리 선택\n2. 문서 편집\n3. 복사 또는 다운로드',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.lightGray300,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _showUserGuide,
                        icon: const Icon(
                          Icons.help_outline,
                          color: AppColors.accentCyan,
                          size: 18,
                        ),
                        label: Text(
                          '상세 가이드 보기',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.accentCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 오른쪽 콘텐츠 영역
          Expanded(
            child: documents.isEmpty
                ? Center(
                    child: Text(
                      '문서를 선택하세요',
                      style: AppTypography.h6.copyWith(
                        color: AppColors.lightGray300,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: EditableDocument(
                          title: doc['title'] as String,
                          fields: doc['fields'] as Map<String, dynamic>,
                          accentColor: selectedTemplate['color'] as Color,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 사용자 가이드 다이얼로그
class _UserGuideDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.charcoal,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    color: AppColors.primaryBlue,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '프로젝트 문서 작성 가이드',
                          style: AppTypography.h5.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '현업에서 사용하는 실전 문서 작성법 A-Z',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.lightGray300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuideSection(
                      '📋 1단계: 카테고리 선택',
                      '''왼쪽 사이드바에서 작성하고 싶은 문서 카테고리를 선택하세요.

카테고리별 특징:
• 기획 문서: 프로젝트 제안서, 요구사항 정의서, 기능 명세서
• 디자인 문서: 디자인 시스템 가이드, UI/UX 설계서
• 개발 문서: 기술 스택 문서, API 명세서, 코드 리뷰 가이드
• 배포 문서: 배포 가이드, 유지보수 가이드

💡 팁: 프로젝트 초기에는 "기획 문서"부터 시작하는 것을 추천합니다.''',
                      AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 24),
                    _buildGuideSection(
                      '✏️ 2단계: 문서 작성 및 편집',
                      '''선택한 카테고리의 문서 템플릿이 오른쪽에 표시됩니다.

작성 방법:
1. 각 섹션의 입력 필드를 클릭하여 내용을 입력합니다
2. 텍스트는 자동으로 저장됩니다 (입력 중에도 실시간 반영)
3. 여러 줄 입력이 가능합니다 (Enter 키로 줄바꿈)

✨ 스마트 기능:
• 편집 모드: 텍스트 필드로 자유롭게 수정
• 미리보기 모드: 최종 문서 형식으로 확인 (편집/미리보기 버튼 클릭)
• 실시간 업데이트: 입력 내용이 즉시 반영됩니다

📝 작성 팁:
• 구체적으로: "사용자 관리 기능" → "관리자가 사용자 목록을 조회하고 권한을 수정할 수 있는 기능"
• 측정 가능하게: "성능 개선" → "페이지 로딩 속도 3초 이내로 단축"
• 기한 명시: "빠른 시일 내" → "2025년 3월 15일까지"
• 담당자 지정: "개발팀" → "백엔드: 김철수, 프론트엔드: 이영희"''',
                      AppColors.highlightGreen,
                    ),
                    const SizedBox(height: 24),
                    _buildGuideSection(
                      '📤 3단계: 문서 내보내기',
                      '''작성한 문서를 활용하는 3가지 방법:

1️⃣ 클립보드 복사 (📋 버튼)
• 문서 내용을 클립보드에 복사합니다
• 다른 프로그램(Word, Notion, 이메일 등)에 붙여넣기 가능
• 즉시 공유하거나 다른 문서에 삽입할 때 유용

2️⃣ 파일 다운로드 (💾 버튼)
• .txt 파일로 다운로드됩니다
• 파일명: "문서제목_날짜.txt" (예: 프로젝트 제안서_2025-12-28.txt)
• 컴퓨터에 저장하여 백업하거나 공유 가능

3️⃣ 편집/미리보기 전환
• "편집" 버튼: 내용 수정 가능
• "미리보기" 버튼: 최종 문서 형식으로 확인
• 복사하거나 다운로드하기 전에 미리보기로 최종 확인 권장''',
                      AppColors.accentCyan,
                    ),
                    const SizedBox(height: 24),
                    _buildGuideSection(
                      '🎯 실전 활용 시나리오',
                      '''시나리오 1: 개인 포트폴리오 프로젝트 시작
1. "기획 문서" → "프로젝트 제안서" 선택
2. 프로젝트 개요, 목표, 일정 작성
3. 다운로드하여 버전 관리 (Git에 커밋)
4. "개발 문서" → "기술 스택 문서" 작성
5. 개발 진행하면서 문서 업데이트

시나리오 2: 취업 포트폴리오 준비
1. "디자인 문서" → "디자인 시스템 가이드" 작성
2. 실제 작업한 컬러, 타이포그래피 정리
3. 미리보기로 확인 후 PDF로 변환
4. 포트폴리오 첨부 자료로 활용

시나리오 3: 팀 프로젝트 협업
1. "기획 문서" → "요구사항 정의서" 작성
2. 클립보드 복사하여 Notion에 붙여넣기
3. 팀원들과 공유하여 피드백 받기
4. 수정 후 최종본 다운로드하여 아카이빙''',
                      Color(0xFF9C27B0),
                    ),
                    const SizedBox(height: 24),
                    _buildGuideSection(
                      '💡 프로 팁',
                      '''문서 작성 고수가 되는 비법:

1. 템플릿 활용
   • 처음부터 완벽하게 작성하려 하지 마세요
   • 템플릿의 예시를 참고하여 프로젝트에 맞게 수정
   • 반복 사용하면서 나만의 템플릿으로 발전

2. 버전 관리
   • 주요 변경사항마다 다운로드하여 백업
   • 파일명에 날짜를 포함하여 버전 구분
   • 예: 제안서_v1.0_2025-01-15.txt

3. 일관성 유지
   • 용어는 프로젝트 전체에서 통일
   • 형식(날짜, 숫자 표기)을 일관되게 유지
   • 섹션 구조를 비슷하게 유지하여 가독성 향상

4. 검토 프로세스
   • 작성 → 하루 뒤 재검토 → 수정 → 최종 확인
   • 다른 사람에게 리뷰 요청
   • 미리보기 모드로 최종 형식 확인

5. 지속적 업데이트
   • 프로젝트 진행 중 변경사항 반영
   • 완료된 항목 체크하며 진행상황 관리
   • 회고 시 문서 참고하여 개선점 도출''',
                      Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.deepSpace.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.highlightGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.highlightGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '문서 작성이 프로젝트 성공의 50%입니다!\n꼼꼼하게 작성한 문서는 개발 과정에서 나침반이 되어줍니다.',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.lightGray300,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 푸터
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.lightGray300.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '닫기',
                      style: TextStyle(color: AppColors.accentCyan),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection(String title, String content, Color accentColor) {
    return Column(
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
                style: AppTypography.h6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.deepSpace.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: accentColor.withOpacity(0.2),
            ),
          ),
          child: Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.lightGray300,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}
