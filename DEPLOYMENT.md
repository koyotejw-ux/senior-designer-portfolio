# 배포 가이드 (Deployment Guide)

정재웅 시니어 프로덕트 디자이너 포트폴리오 웹사이트 배포 가이드입니다.

## 🚀 배포 방법 개요

로컬 환경에서 Flutter 웹 프로덕션 빌드 시 shader compiler 이슈가 발생하므로, **CI/CD 환경을 활용한 자동 배포**를 권장합니다.

### 배포 옵션

1. **Firebase Hosting** (권장) - 자동 빌드 및 무료 호스팅
2. **GitHub Pages** - GitHub Actions 활용 자동 배포
3. **Vercel** - Git 연동 자동 배포
4. **Netlify** - Git 연동 자동 배포

---

## 📦 Option 1: Firebase Hosting (권장)

### 1단계: Firebase 프로젝트 설정

```bash
# Firebase CLI 설치 (아직 설치하지 않았다면)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# Firebase 프로젝트 초기화
firebase init hosting

# 설정 시 선택 사항:
# - Public directory: build/web
# - Configure as single-page app: Yes
# - Set up automatic builds with GitHub: Yes (선택 사항)
```

### 2단계: GitHub 리포지토리 생성 및 푸시

```bash
# GitHub에서 새 리포지토리 생성 후 URL 복사
# 예: https://github.com/yourusername/senior-designer-portfolio.git

# 로컬 리포지토리와 연결
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git

# main 브랜치로 푸시
git branch -M main
git push -u origin main
```

### 3단계: GitHub Actions 자동 배포 설정

`.github/workflows/firebase-hosting.yml` 파일이 자동 생성되었을 것입니다.

만약 없다면 다음 내용으로 생성:

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.5'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release

      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: your-firebase-project-id
```

### 4단계: Firebase Service Account 설정

1. Firebase Console → Project Settings → Service Accounts
2. "Generate new private key" 클릭
3. 다운로드된 JSON 파일 내용을 복사
4. GitHub Repository → Settings → Secrets and variables → Actions
5. New repository secret 클릭
6. Name: `FIREBASE_SERVICE_ACCOUNT`
7. Value: JSON 파일 내용 붙여넣기

### 5단계: 배포 확인

```bash
# main 브랜치에 푸시하면 자동으로 배포됩니다
git push origin main

# GitHub Actions 탭에서 배포 진행 상황 확인
# 완료 후 Firebase Console에서 배포된 URL 확인
```

---

## 📦 Option 2: GitHub Pages

### 1단계: GitHub 리포지토리 생성

```bash
# GitHub에서 새 리포지토리 생성
# Repository name: senior-designer-portfolio
# Public or Private 선택

# 로컬과 연결
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git
git branch -M main
git push -u origin main
```

### 2단계: GitHub Actions 워크플로우 생성

`.github/workflows/deploy.yml` 파일 생성:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: write

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.5'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release --base-href "/senior-designer-portfolio/"

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

### 3단계: GitHub Pages 활성화

1. Repository → Settings → Pages
2. Source: Deploy from a branch
3. Branch: gh-pages / (root)
4. Save

### 4단계: 배포 URL 확인

배포 완료 후 URL: `https://yourusername.github.io/senior-designer-portfolio/`

---

## 📦 Option 3: Vercel

### 1단계: Vercel 계정 생성

1. https://vercel.com 접속
2. GitHub 계정으로 로그인

### 2단계: GitHub 리포지토리 푸시

```bash
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git
git branch -M main
git push -u origin main
```

### 3단계: Vercel에서 프로젝트 Import

1. Vercel Dashboard → Add New → Project
2. Import Git Repository 선택
3. senior-designer-portfolio 리포지토리 선택
4. Framework Preset: Other
5. Build Command: `flutter build web`
6. Output Directory: `build/web`
7. Deploy 클릭

### 4단계: 빌드 설정

Vercel은 Flutter를 자동으로 감지하지 못하므로, 커스텀 빌드 스크립트 필요:

`vercel.json` 파일 생성:

```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null
}
```

---

## 📦 Option 4: Netlify

### 1단계: Netlify 계정 생성

1. https://www.netlify.com 접속
2. GitHub 계정으로 로그인

### 2단계: GitHub 리포지토리 푸시

```bash
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git
git branch -M main
git push -u origin main
```

### 3단계: Netlify에서 사이트 생성

1. Netlify Dashboard → Add new site → Import an existing project
2. GitHub 선택 및 리포지토리 연결
3. Build settings:
   - Build command: `flutter build web`
   - Publish directory: `build/web`
4. Deploy site 클릭

### 4단계: netlify.toml 설정 (선택 사항)

프로젝트 루트에 `netlify.toml` 파일 생성:

```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

---

## 🔧 로컬 개발 환경

### 개발 모드 실행

```bash
# 개발 서버 실행 (포트 8080)
flutter run -d chrome --web-port 8080

# 또는 다른 포트로 실행
flutter run -d chrome --web-port 3000
```

### 코드 품질 검사

```bash
# 정적 분석
flutter analyze

# 코드 포맷팅
flutter format .

# 테스트 실행 (테스트 파일이 있다면)
flutter test
```

---

## 🌐 커스텀 도메인 설정

### Firebase Hosting

1. Firebase Console → Hosting → Add custom domain
2. 도메인 입력 (예: portfolio.coyotejw.com)
3. DNS 레코드 추가:
   - Type: A
   - Host: @
   - Value: Firebase 제공 IP 주소

### GitHub Pages

1. Repository → Settings → Pages → Custom domain
2. 도메인 입력 후 Save
3. DNS 레코드 추가:
   - Type: CNAME
   - Host: www
   - Value: yourusername.github.io

### Vercel

1. Project Settings → Domains → Add
2. 도메인 입력
3. Vercel이 제공하는 DNS 레코드 추가

### Netlify

1. Site settings → Domain management → Add custom domain
2. 도메인 입력
3. Netlify가 제공하는 DNS 레코드 추가

---

## ⚠️ 알려진 이슈 및 해결 방법

### Issue 1: 로컬 프로덕션 빌드 실패

**문제**: `flutter build web --release` 실행 시 shader compiler (impellerc) 크래시

**원인**: 로컬 Windows 환경의 shader compiler 이슈

**해결 방법**:
- ✅ CI/CD 환경(GitHub Actions, Firebase, Vercel 등)에서 빌드 - **권장**
- ⚠️ 개발 모드(`flutter run`)로 테스트 가능
- ⚠️ 다른 개발 환경(Mac, Linux)에서 빌드 시도

### Issue 2: 폰트 로딩 문제

**문제**: 배포 후 Pretendard 폰트가 로드되지 않음

**해결 방법**:
- `web/index.html`에서 CDN 링크 확인
- 네트워크 탭에서 폰트 로딩 상태 확인
- 필요시 로컬 폰트 파일로 대체

### Issue 3: 이미지/SVG 로딩 문제

**문제**: 배포 후 assets 이미지가 표시되지 않음

**해결 방법**:
- `pubspec.yaml`의 assets 경로 확인
- 빌드 후 `build/web/assets` 디렉토리 확인
- base-href 설정 확인 (GitHub Pages의 경우)

---

## 📊 배포 후 체크리스트

- [ ] 사이트 로딩 속도 확인 (Lighthouse 점수)
- [ ] 모바일 반응형 디자인 확인
- [ ] 다크/라이트 모드 전환 확인
- [ ] PWA 설치 가능 여부 확인
- [ ] SEO 메타 태그 확인 (View Page Source)
- [ ] Open Graph 이미지 확인 (소셜 미디어 공유)
- [ ] 모든 섹션 스크롤 애니메이션 확인
- [ ] 연락처 정보 정확성 확인
- [ ] Google Analytics 연동 (선택 사항)
- [ ] Google Search Console 등록 (선택 사항)

---

## 🔐 환경 변수 설정 (Firebase 사용 시)

### Firebase 환경 변수 파일 생성

`.env` 파일 (Git에 커밋하지 말 것!):

```
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_auth_domain
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_storage_bucket
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

`.gitignore`에 추가되어 있는지 확인:
```
.env
.env.local
.env.production
```

---

## 📈 모니터링 및 분석

### Google Analytics 추가 (선택 사항)

`web/index.html`의 `<head>` 섹션에 추가:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### Firebase Analytics 추가 (선택 사항)

Firebase Console → Analytics → Enable

---

## 🚨 긴급 롤백 방법

### Git 이전 커밋으로 되돌리기

```bash
# 커밋 히스토리 확인
git log --oneline

# 특정 커밋으로 되돌리기 (로컬만)
git reset --hard <commit-hash>

# 원격 저장소에 강제 푸시 (주의!)
git push -f origin main
```

### Firebase Hosting 이전 버전으로 롤백

```bash
# 배포 히스토리 확인
firebase hosting:releases:list

# 특정 버전으로 롤백
firebase hosting:rollback
```

---

## 📞 문의 및 지원

**개발자**: 정재웅 (Jaewoong Jung)
- Email: coyotejw@naver.com
- Phone: +82 10 4375 3599
- Location: Seoul, South Korea

---

## 📄 라이선스

© 2025 Jaewoong Jung. All rights reserved.
