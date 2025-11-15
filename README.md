# Senior Designer Portfolio

정재웅 시니어 프로덕트 디자이너 포트폴리오 웹사이트

## 🎯 프로젝트 개요

19년 경력의 시니어 프로덕트 디자이너를 위한 프리미엄 포트폴리오 플랫폼입니다.
AI/ML 기술과 데이터 분석 전문성을 갖춘 디자이너로서, 대기업 채용을 목표로 제작된 고급스러운 디자인의 웹 애플리케이션입니다.

## ✨ 주요 기능

### 현재 구현된 기능
- ✅ **히어로 섹션**: 미니멀하고 강력한 첫인상, CJW 브랜드 로고
  - 신비로운 파티클 애니메이션 배경
  - 폴리곤 네트워크 배경 (다크 모드)
  - 반짝이는 파티클 효과 및 연결선
- ✅ **About 섹션**: 실제 경력 스토리 + 통계 시각화 (19년 경력, 100+ 프로젝트, 350만+ 사용자, 100% 완료율)
- ✅ **Expertise 섹션**: 4개 전문 분야 (Design Systems, AI/ML, Data Analytics, Development)
- ✅ **Experience 섹션**: 전체 경력 타임라인 (ING People, 현대HT, BluestoneSoft, NEXON, YNK코리아)
- ✅ **Project Journey 섹션**: 프로젝트 프로세스 스토리텔링
  - 문제 발견 → 가설 검증 → 디자인/개발 → 배포/모니터링
  - 데이터 기반 의사결정 프로세스 시각화
  - 대기업에 어필할 수 있는 체계적인 접근 방식 강조
  - 타임라인 형식으로 단계별 상세 설명
- ✅ **Portfolio Gallery**: 실제 프로젝트 5개 (AIA+ SENIOR MODE, WALLPAD, HT HOME 2.0, SOULARK, CLOSERS)
  - 호버 애니메이션 (카드 lift-up + shadow)
  - 프로젝트별 그라디언트 색상
  - 카테고리 배지 및 기술 스택 태그
- ✅ **Documents 페이지**: 이력서/경력기술서/자기소개서/포트폴리오 뷰어
  - 문서 타입별 필터링 (전체, 이력서, 자기소개서, 경력기술서, 포트폴리오)
  - 반응형 그리드 레이아웃 (모바일 1열, 태블릿 2열, 데스크탑 3열)
  - 문서 상세 뷰어 with PDF 다운로드/인쇄 기능
  - 버전 관리 시스템 준비 완료
- ✅ **Contact 섹션**: 연락처 정보 및 CTA
- ✅ **다크/라이트 모드**: 완벽한 테마 전환
- ✅ **반응형 디자인**: 모바일/태블릿/데스크탑 지원
- ✅ **스크롤 기반 헤더**: 히어로 섹션 벗어나면 로고 표시 + 네비게이션 (Home/Resume/Documents/Portfolio)
- ✅ **스크롤 진행률 표시기**:
  - 상단 그라디언트 프로그레스 바
  - 우하단 원형 퍼센티지 인디케이터
- ✅ **섹션 reveal 애니메이션**: 스크롤 시 섹션별 fade-in + slide-up 효과
- ✅ **애니메이션**: flutter_animate 기반 부드러운 진입 효과
- ✅ **파티클 시스템**: 신비로운 배경 애니메이션 (60개 파티클, 연결선, 글로우 효과)
- ✅ **스무스 스크롤**: 부드러운 스크롤 트랜지션 효과

### 향후 개발 예정
- 🔲 **Admin CMS**: 이력서, 자기소개서, 경력기술서, 포트폴리오 관리
- 🔲 **버전 관리**: 문서 버전 태깅 시스템
- 🔲 **PDF 다운로드**: 4가지 문서 타입 PDF 생성
- 🔲 **Firebase 연동**: 인증, Firestore, Storage
- 🔲 **포트폴리오 상세 페이지**: 각 프로젝트 케이스 스터디
- 🔲 **패럴랙스 스크롤 섹션**: 깊이감 있는 스크롤 효과 (섹션별 적용)

## 🎨 디자인 시스템

### 브랜드 컬러
- **Primary Blue**: `#0068B3`
- **Accent Cyan**: `#009DDC`
- **Highlight Green**: `#C1D72E`

### 타이포그래피
- **폰트**: Pretendard (CDN)
- **크기**: 11px ~ 96px (반응형)
- **굵기**: w400 ~ w800

### 테마
- **다크 모드**: `#0A0E1A` 배경, 고대비 텍스트
- **라이트 모드**: `#FAFBFC` 배경, 부드러운 색상

## 🛠 기술 스택

### Frontend
- **Flutter 3.x**: 크로스 플랫폼 프레임워크
- **Riverpod 2.5.1**: 상태 관리
- **go_router 14.2.7**: 라우팅
- **flutter_svg 2.0.10**: SVG 렌더링
- **flutter_animate 4.5.0**: 애니메이션

### Backend (예정)
- **Firebase Auth**: 사용자 인증
- **Cloud Firestore**: 데이터베이스
- **Cloud Storage**: 파일 저장

### 아키텍처
- **Clean Architecture**: features/core 분리
- **Feature-First**: 기능별 모듈화
- **Atomic Design**: 컴포넌트 구조

## 📁 프로젝트 구조

```
senior_designer_portfolio/
├── lib/
│   ├── core/
│   │   ├── constants/        # 상수 정의
│   │   ├── router/           # 라우팅 설정
│   │   ├── theme/            # 테마 시스템
│   │   └── widgets/          # 공통 위젯
│   ├── features/
│   │   └── home/
│   │       └── presentation/
│   │           ├── pages/    # 페이지
│   │           └── widgets/  # 섹션 위젯
│   └── main.dart             # 진입점
├── web/
│   └── index.html            # Pretendard 폰트 로드
├── assets/
│   └── images/
│       └── logo.svg          # CJW 브랜드 로고
└── pubspec.yaml              # 패키지 설정
```

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.0 이상
- Chrome (웹 개발)
- Git

### 설치 및 실행

```bash
# 레포지토리 클론
git clone <repository-url>
cd senior_designer_portfolio

# 패키지 설치
flutter pub get

# 웹 실행
flutter run -d chrome --web-port 8080
```

### 개발 모드
```bash
# 핫 리로드 활성화
flutter run -d chrome --web-port 8080

# 핫 리로드: r
# 핫 리스타트: R
# 종료: q
```

## 🎯 브랜드 아이덴티티

### CJW 로고
- 위치: `assets/images/logo.svg`
- 색상: 다크 모드(원본), 라이트 모드(#0068B3 틴트)
- 크기: 모바일 240px, 태블릿 360px, 데스크탑 480px

### 디자인 철학
- **미니멀리즘**: 불필요한 요소 제거, 본질에 집중
- **프리미엄**: 고급스러운 간격, 타이포그래피, 색상
- **대기업 스타일**: 신뢰감, 전문성, 세련됨
- **강약 대비**: 명확한 계층 구조, 시각적 리듬

## 📱 반응형 브레이크포인트

- **모바일**: < 768px
- **태블릿**: 768px ~ 1024px
- **데스크탑**: > 1024px

## 🎨 애니메이션

- **진입 효과**: fadeIn + slideY/slideX
- **지연 시간**: 200ms ~ 1600ms (순차적)
- **지속 시간**: 600ms ~ 1000ms
- **곡선**: easeOut, easeInOut

## 👨‍💻 개발자

**정재웅 (Jaewoong Jung)**
- Email: coyotejw@naver.com
- Phone: +82 10 4375 3599
- Location: Seoul, South Korea

## 📄 라이선스

© 2025 Jaewoong Jung. All rights reserved.

---

**Status**: ✅ 기본 포트폴리오 완성 | 🔲 Admin CMS 개발 예정
