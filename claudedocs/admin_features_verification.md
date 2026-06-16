# Admin Features Verification & Testing Guide

## 새로 추가된 기능 (Newly Added Features)

### 1. ✅ Structure Tab (구조 탭)
**Location**: Admin → Structure Tab (7번째 탭)

**Features**:
- 📁 **File Structure Tree**: 전체 프로젝트 파일 계층 구조 시각화
- 🔄 **Data Flow Diagram**: 데이터 흐름 설명 (db.json → providers → UI)
- 🎯 **Component Impact Map**: 어드민 수정 시 영향받는 화면 매핑

**테스트 방법**:
1. Admin 페이지 접속
2. "Structure" 탭 클릭
3. 왼쪽 패널에서 파일 구조 확인
4. 오른쪽 패널에서 Component Impact Map 확인
5. 각 편집기가 어떤 화면에 영향을 주는지 확인

**확인 사항**:
- [ ] 파일 트리가 올바르게 표시됨
- [ ] 각 파일에 한글 설명이 표시됨
- [ ] Component Impact Map에 4개 편집기 정보 표시
- [ ] "영향받는 화면" 목록이 정확함

---

### 2. ✅ Design System Tab (디자인 시스템 탭)
**Location**: Admin → Design System Tab (8번째 탭)

**Features**:
- 🎨 **5개 서브탭**:
  1. **Colors**: 전체 색상 팔레트 (Primary, Accent, Neutral, Semantic)
  2. **Typography**: 타이포그래피 시스템 (Display, Heading, Body, Caption)
  3. **Atoms**: 기본 컴포넌트 (PrimaryButton, SecondaryButton, TextInput)
  4. **Molecules**: 조합 컴포넌트 (InfoCard)
  5. **Organisms**: 복합 컴포넌트 (향후 추가 예정)

**테스트 방법**:
1. Admin → "Design System" 탭 클릭
2. Colors 탭에서 색상 팔레트 확인
3. Typography 탭에서 폰트 스타일 확인
4. Atoms 탭에서 버튼과 입력 필드 미리보기 확인
5. Molecules 탭에서 InfoCard 미리보기 확인

**확인 사항**:
- [ ] 모든 색상이 올바르게 표시됨
- [ ] 타이포그래피 예제가 올바른 스타일로 표시됨
- [ ] Atoms 컴포넌트가 실제로 동작함 (버튼 클릭, 입력 가능)
- [ ] InfoCard가 올바른 스타일로 표시됨
- [ ] 각 컴포넌트에 사용법 코드가 표시됨

---

### 3. ✅ UI Preview Tab (UI 미리보기 탭)
**Location**: Admin → UI Preview Tab (9번째 탭)

**Features**:
- **3-Panel Layout**:
  1. **Left Panel**: 카테고리 및 컴포넌트 선택
  2. **Center Panel**: 실시간 컴포넌트 미리보기
  3. **Right Panel**: 속성 편집기 + 코드 뷰어

**지원 컴포넌트**:
- Atoms: PrimaryButton, SecondaryButton, TextInput
- Molecules: InfoCard
- Organisms: HeroSection, PortfolioGallery (향후 추가)

**테스트 방법**:
1. Admin → "UI Preview" 탭 클릭
2. 왼쪽에서 "Atoms" 카테고리 선택
3. "PrimaryButton" 컴포넌트 선택
4. 오른쪽 패널에서 속성 수정:
   - text 변경 → 버튼 텍스트 실시간 변경
   - isLoading 토글 → 로딩 상태 확인
5. 코드 뷰어에서 사용 예제 확인
6. Copy 버튼으로 코드 복사

**확인 사항**:
- [ ] 컴포넌트 선택 시 중앙에 미리보기 표시
- [ ] 속성 변경 시 실시간으로 UI 업데이트
- [ ] isLoading 토글이 작동함
- [ ] text 입력이 즉시 반영됨
- [ ] 코드 복사 기능이 작동함
- [ ] "Button clicked!" 스낵바가 표시됨

---

## Atomic Design System 구조

```
lib/core/design_system/
├── atoms/
│   ├── buttons/
│   │   ├── primary_button.dart          ✅ 완성
│   │   └── secondary_button.dart        ✅ 완성
│   └── inputs/
│       └── text_input.dart              ✅ 완성
│
├── molecules/
│   └── cards/
│       └── info_card.dart               ✅ 완성
│
└── organisms/
    └── (향후 추가)
```

**컴포넌트 사용법**:

### PrimaryButton
```dart
import 'package:senior_designer_portfolio/core/design_system/atoms/buttons/primary_button.dart';

PrimaryButton(
  text: 'Click Me',
  onPressed: () {},
  icon: Icons.check,
  isLoading: false,
)
```

### SecondaryButton
```dart
import 'package:senior_designer_portfolio/core/design_system/atoms/buttons/secondary_button.dart';

SecondaryButton(
  text: 'Cancel',
  onPressed: () {},
  isLoading: false,
)
```

### TextInput
```dart
import 'package:senior_designer_portfolio/core/design_system/atoms/inputs/text_input.dart';

TextInput(
  label: 'Email',
  hint: 'Enter your email',
  onChanged: (value) => print(value),
  errorText: null,
)
```

### InfoCard
```dart
import 'package:senior_designer_portfolio/core/design_system/molecules/cards/info_card.dart';

InfoCard(
  title: 'Card Title',
  accentColor: AppColors.accentCyan,
  onEdit: () {},
  onDelete: () {},
  child: Text('Content goes here'),
)
```

---

## 데이터 동기화 확인 (Admin ↔ Frontend Sync)

### 테스트 시나리오:

#### 1. Profile 수정 테스트
1. Admin → Profile 탭
2. Name 변경: "홍길동" → "김철수"
3. Save 버튼 클릭
4. Frontend 홈페이지로 이동
5. About Section에서 "김철수" 확인

**예상 결과**: ✅ About Section과 Resume Section에 자동 반영

---

#### 2. Experience 수정 테스트
1. Admin → Experience 탭
2. BMSoft 경력 확인 (2008.03 ~ 2008.07)
3. C&D 경력 확인 (2005.11 ~ 2006.12)
4. 기존 경력 하나 수정 (예: position 변경)
5. Save 후 Frontend Experience Section 확인

**예상 결과**: ✅ Experience Section과 Resume Section에 자동 반영

---

#### 3. Project 수정 테스트
1. Admin → Projects 탭
2. 프로젝트 하나 선택하여 title 변경
3. Save 후 Frontend Portfolio Gallery 확인
4. 해당 프로젝트 클릭하여 Detail Page 확인

**예상 결과**: ✅ Gallery와 Detail Page에 자동 반영

---

#### 4. Skill 수정 테스트
1. Admin → Skills 탭
2. 새로운 스킬 추가 (예: "Figma")
3. Save 후 Frontend Skills Section 확인

**예상 결과**: ✅ Skills Section에 즉시 표시

---

## PDF 생성 확인

### 1. Resume PDF (이력서)
**테스트**:
1. Admin → Resume 탭
2. "이력서 PDF 생성" 버튼 클릭
3. PDF 다운로드
4. **확인 사항**:
   - [ ] 한글 텍스트가 정상적으로 표시됨 (깨지지 않음)
   - [ ] BMSoft (2008.03~2008.07) 경력 포함
   - [ ] C&D (2005.11~2006.12) 경력 포함
   - [ ] 프로필 사진 위치에 이미지 또는 placeholder
   - [ ] 모든 섹션이 대기업 기준에 맞게 작성됨

**Note**: 프로필 사진은 `server/data/images/profile.jpg` 업로드 후 표시됨

---

### 2. Career Certificate PDF (경력증명서)
**테스트**:
1. Admin → Resume 탭
2. "경력증명서 PDF 생성" 버튼 클릭
3. PDF 다운로드
4. **확인 사항**:
   - [ ] 한글이 정상 표시됨
   - [ ] 모든 경력 (7개) 포함
   - [ ] 날짜 형식 정확함
   - [ ] 공식 문서 형식

---

### 3. Cover Letter PDF (자기소개서)
**테스트**:
1. Admin → Resume 탭
2. "자기소개서 PDF 생성" 버튼 클릭
3. PDF 다운로드
4. **확인 사항**:
   - [ ] 한글이 정상 표시됨
   - [ ] 대기업 기준 내용 충실
   - [ ] 문단 구조 명확
   - [ ] 전문적인 톤

---

## 알려진 이슈 및 다음 단계

### ✅ 완료된 작업
1. Server 데이터 로딩 문제 해결 (절대 경로 사용)
2. PDF 한글 폰트 지원 (Noto Sans KR)
3. BMSoft, C&D 경력 추가
4. Atomic Design System 구조 생성
5. 3개 Admin 페이지 추가 (Structure, Design System, UI Preview)
6. Admin 탭 9개로 확장

### 📋 향후 작업 (Optional)
1. **프로필 사진 업로드**:
   - `server/data/images/profile.jpg` 파일 업로드
   - 또는 Admin에서 이미지 업로드 기능 추가

2. **기존 컴포넌트 리팩토링**:
   - `hero_section.dart`, `portfolio_gallery_section.dart` 등을
   - Atomic Design 컴포넌트를 사용하도록 수정

3. **Design System 확장**:
   - 더 많은 Atoms 추가 (Badge, Chip, Avatar 등)
   - Molecules 추가 (SearchBar, Pagination 등)
   - Organisms 추가 (Navigation, Footer 등)

4. **UI Preview 확장**:
   - Organisms 컴포넌트 미리보기 추가
   - 반응형 뷰포트 테스트 기능
   - 다크모드 토글

5. **코드 생성기**:
   - UI Preview에서 설정한 props로 코드 자동 생성
   - 클립보드 복사 기능 강화

---

## 빠른 테스트 체크리스트

### Admin 기능 테스트
- [ ] Structure 탭 - 파일 구조 표시 확인
- [ ] Design System 탭 - 5개 서브탭 모두 확인
- [ ] UI Preview 탭 - 컴포넌트 실시간 수정 확인
- [ ] Profile Editor → Frontend About Section 동기화
- [ ] Experience Editor → BMSoft/C&D 표시 확인
- [ ] Project Editor → Portfolio Gallery 동기화
- [ ] Skill Editor → Skills Section 동기화

### PDF 생성 테스트
- [ ] Resume PDF - 한글 정상, BMSoft/C&D 포함
- [ ] Career Certificate PDF - 한글 정상, 7개 경력 포함
- [ ] Cover Letter PDF - 한글 정상, 대기업 기준 내용

### Atomic Design System 테스트
- [ ] PrimaryButton - 클릭, 로딩 상태 확인
- [ ] SecondaryButton - 스타일 확인
- [ ] TextInput - 입력, 에러 표시 확인
- [ ] InfoCard - 제목, 내용, 액션 버튼 확인

---

## 문제 발생 시 확인 사항

### Server 문제
```bash
# 서버 실행 확인
cd server
dart run bin/server.dart

# 데이터 파일 확인
cat server/data/db.json
```

### Frontend 빌드 문제
```bash
# 의존성 설치
flutter pub get

# 빌드 확인
flutter run -d chrome
```

### PDF 폰트 문제
- 인터넷 연결 확인 (Noto Sans KR 다운로드 필요)
- 브라우저 콘솔에서 폰트 로드 에러 확인

---

## 추가 리소스

### 파일 위치 참조
- **Admin Pages**: `lib/features/admin/presentation/pages/`
- **Design System**: `lib/core/design_system/`
- **Server Data**: `server/data/db.json`
- **Server Images**: `server/data/images/`
- **PDF Widgets**: `lib/features/admin/presentation/widgets/professional_resume_pdf.dart`

### 주요 Provider
- `content_provider.dart` - 서버 데이터 로드
- `resume_provider.dart` - 이력서 하드코딩 데이터 (BMSoft/C&D 포함)

---

**작성일**: 2025-12-27
**버전**: v1.0
**상태**: 모든 기능 구현 완료 ✅
