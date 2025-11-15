# GitHub 푸시 및 배포 빠른 가이드

## 현재 프로젝트 상태

- Git 상태: **Working tree clean**
- 코드 품질: **No issues found!**
- 커밋 수: **3개**
- 배포 준비: **완료**

---

## Step 1: GitHub 리포지토리 생성

1. **GitHub 웹사이트 접속**
   - https://github.com 로그인

2. **새 리포지토리 생성**
   - 우측 상단 `+` → `New repository` 클릭
   - Repository name: `senior-designer-portfolio`
   - Description: `19년 경력 시니어 프로덕트 디자이너 포트폴리오 웹사이트`
   - Public/Private 선택 (추천: Public)
   - **Initialize this repository with: 선택 안 함** (이미 로컬에 있음)
   - `Create repository` 클릭

3. **리포지토리 URL 복사**
   - 생성 후 표시되는 URL 복사
   - 예: `https://github.com/yourusername/senior-designer-portfolio.git`

---

## Step 2: 로컬 Git과 GitHub 연결 및 푸시

```bash
# 프로젝트 디렉토리로 이동
cd "D:\02.포트폴리오\2025ai포트폴리오사이트\senior_designer_portfolio"

# GitHub 리포지토리와 연결 (yourusername을 실제 GitHub 사용자명으로 변경)
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git

# main 브랜치로 변경
git branch -M main

# GitHub에 푸시
git push -u origin main
```

**푸시 완료!** 이제 GitHub에서 코드를 확인할 수 있습니다.

---

## Step 3: 배포 방법 선택

### Option A: Firebase Hosting (권장)

**장점:**
- 무료 호스팅
- 자동 SSL 인증서
- 빠른 CDN
- GitHub Actions 자동 배포

**단계:**

1. **Firebase CLI 설치**
```bash
npm install -g firebase-tools
```

2. **Firebase 로그인**
```bash
firebase login
```

3. **Firebase 프로젝트 초기화**
```bash
firebase init hosting
```

선택 사항:
- Use an existing project or create a new one
- Public directory: `build/web`
- Configure as single-page app: `Yes`
- Set up automatic builds with GitHub: `Yes`

4. **GitHub Actions 설정**

Firebase가 `.github/workflows/firebase-hosting-pull-request.yml`과 `.github/workflows/firebase-hosting-merge.yml` 파일을 자동 생성합니다.

5. **Firebase Service Account 설정**

- Firebase Console → Project Settings → Service Accounts
- `Generate new private key` 클릭
- JSON 파일 다운로드
- GitHub Repository → Settings → Secrets → Actions
- `New repository secret` 클릭
- Name: `FIREBASE_SERVICE_ACCOUNT`
- Value: JSON 내용 붙여넣기

6. **푸시하면 자동 배포**
```bash
git push origin main
```

배포 완료! Firebase Hosting URL에서 확인 가능합니다.

---

### Option B: GitHub Pages

**장점:**
- 완전 무료
- GitHub 통합
- 간단한 설정

**단계:**

1. **GitHub Actions 워크플로우 파일 생성**

`.github/workflows/deploy.yml` 파일 생성:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

permissions:
  contents: write

jobs:
  build-and-deploy:
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
        run: flutter build web --release --base-href "/senior-designer-portfolio/"

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

2. **GitHub Pages 활성화**
- Repository → Settings → Pages
- Source: `Deploy from a branch`
- Branch: `gh-pages` / `(root)`
- Save

3. **푸시하면 자동 배포**
```bash
git add .github/workflows/deploy.yml
git commit -m "ci: Add GitHub Pages deployment workflow"
git push origin main
```

배포 URL: `https://yourusername.github.io/senior-designer-portfolio/`

---

### Option C: Vercel (추천)

**장점:**
- 무료 플랜 제공
- 자동 HTTPS
- 매우 빠른 배포
- 실시간 프리뷰

**단계:**

1. **Vercel 웹사이트 접속**
   - https://vercel.com
   - GitHub 계정으로 로그인

2. **프로젝트 Import**
   - `Add New` → `Project`
   - GitHub 리포지토리 선택: `senior-designer-portfolio`
   - Framework Preset: `Other`

3. **빌드 설정**
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
   - Install Command: `flutter pub get`

4. **Deploy 클릭**

배포 완료! Vercel이 자동으로 URL을 제공합니다.

**주의:** Vercel이 Flutter를 자동 감지하지 못할 수 있으므로, 프로젝트 루트에 `vercel.json` 파일 추가:

```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null,
  "installCommand": "flutter pub get"
}
```

---

### Option D: Netlify

**장점:**
- 무료 플랜
- 간단한 설정
- 폼 처리 기능

**단계:**

1. **Netlify 웹사이트 접속**
   - https://www.netlify.com
   - GitHub 계정으로 로그인

2. **사이트 생성**
   - `Add new site` → `Import an existing project`
   - GitHub 선택
   - 리포지토리: `senior-designer-portfolio`

3. **빌드 설정**
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`

4. **Deploy site 클릭**

배포 완료! Netlify가 자동으로 URL을 제공합니다.

**선택 사항:** `netlify.toml` 파일 추가:

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

## Step 4: 커스텀 도메인 연결 (선택 사항)

### Firebase Hosting
1. Firebase Console → Hosting → Add custom domain
2. 도메인 입력 (예: `portfolio.coyotejw.com`)
3. DNS A 레코드 추가

### GitHub Pages
1. Repository Settings → Pages → Custom domain
2. 도메인 입력
3. DNS CNAME 레코드 추가: `yourusername.github.io`

### Vercel
1. Project Settings → Domains → Add
2. 도메인 입력
3. Vercel 제공 DNS 레코드 추가

### Netlify
1. Site settings → Domain management → Add custom domain
2. 도메인 입력
3. Netlify 제공 DNS 레코드 추가

---

## 빠른 명령어 참조

### Git 명령어
```bash
# 상태 확인
git status

# 최근 커밋 보기
git log --oneline -5

# 원격 저장소 확인
git remote -v

# 브랜치 확인
git branch

# 푸시
git push origin main
```

### Flutter 명령어
```bash
# 코드 품질 검사
flutter analyze

# 개발 서버 실행
flutter run -d chrome --web-port 8080

# 의존성 설치
flutter pub get

# 캐시 정리
flutter clean
```

---

## 배포 후 체크리스트

- [ ] 사이트가 정상적으로 로드되는지 확인
- [ ] 모바일 반응형 확인 (DevTools F12)
- [ ] 다크/라이트 모드 전환 확인
- [ ] 모든 섹션 스크롤 애니메이션 확인
- [ ] 연락처 정보 정확성 확인 (이메일, 전화번호)
- [ ] SEO 확인 (View Page Source - meta 태그)
- [ ] Open Graph 이미지 확인 (소셜 미디어 공유 테스트)
- [ ] PWA 설치 가능 여부 확인 (Chrome 주소창 설치 아이콘)
- [ ] Lighthouse 점수 확인 (F12 → Lighthouse 탭)

---

## 문제 해결

### "Permission denied" 에러
```bash
# SSH 키 설정이 필요합니다
# HTTPS 대신 SSH 사용
git remote set-url origin git@github.com:yourusername/senior-designer-portfolio.git
```

### "Remote already exists" 에러
```bash
# 기존 remote 제거 후 다시 추가
git remote remove origin
git remote add origin https://github.com/yourusername/senior-designer-portfolio.git
```

### Firebase 배포 실패
```bash
# Firebase 재로그인
firebase logout
firebase login

# 프로젝트 재초기화
firebase init hosting
```

---

## 프로젝트 정보

**개발자:** 정재웅 (Jaewoong Jung)
**이메일:** coyotejw@naver.com
**전화:** +82 10 4375 3599
**경력:** 19년
**기술 스택:** Flutter 3.35.5, Riverpod, Firebase

**포트폴리오 프로젝트:**
- AIA+ SENIOR MODE (ING People, 2025)
- WALLPAD (Hyundai HT, 2021-2023)
- HT HOME 2.0 (Hyundai HT, 2021-2023)
- SOULARK (BluestoneSoft, 2016-2017)
- CLOSERS (NEXON Korea, 2014)

---

**배포 성공을 기원합니다!** 🚀
