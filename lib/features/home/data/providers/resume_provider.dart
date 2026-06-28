import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_model.dart';

final resumeProvider = Provider<ResumeModel>((ref) {
  return ResumeModel(
    id: 'resume_1',
    photoUrl: 'http://localhost:8080/images/profile_photo.jpg',
    personalInfo: const PersonalInfo(
      name: '정재웅',
      birthDate: '1979. 08. 14',
      address: '고양시 덕양구 향기5로 66',
      militaryService: '육군 병장 만기전역 (1999.11 ~ 2002.02)',
      phone: '010-4375-3599',
      email: 'coyotejw@naver.com',
    ),
    education: const [
      Education(
        period: '2006.03 ~ 2008.02',
        institution: '평생교육진흥원 학점은행제',
        major: '시각디자인학사 졸업',
        gpa: '(4.25/4.5)',
      ),
      Education(
        period: '1999.03 ~ 2004.02',
        institution: '청강문화산업대학교',
        major: '애니메이션과 (3D) 졸업',
        gpa: '(3.34/4.0)',
      ),
    ],
    careers: const [
      Career(
        period: '2026.01 ~ 현재',
        company: 'Independent Projects (Personal)',
        department: 'Personal',
        position: '1인 풀스택 개발',
        role: 'AI 에이전트 페어 프로그래밍 기반 글로벌 앱 6종 기획/디자인/개발/런칭 및 마케팅 총괄',
        projects: [
          'ChatGPT Codex, Gemini Antigravity, Anthropic Claude 등 최신 LLM 에이전트와의 페어 프로그래밍을 통한 초고속 1인 풀스택 개발 프로세스 구축',
          'Flutter 및 Unity3D를 연동하여 기획부터 UI/UX 디자인, 클라이언트/서버 개발, 앱스토어 심사 통과까지 개발 라이프사이클 전 과정 주도',
          'AI 에이전트를 연동한 글로벌 다국어 SEO/ASO(앱스토어 최적화), 마케팅 크리에이티브 및 글로벌 광고 카피라이팅/프로모션 자동화 파이프라인 수립',
        ],
        achievements: [
          '전통적 개발 프로세스 대비 리드타임 70% 단축 및 글로벌 22개국 다국어 로컬라이징 앱 6종 단독 출시 완료',
          '구글 애드몹(AdMob) 및 인앱 결제(IAP) 연동을 통한 비즈니스 모델(BM) 구축 및 글로벌 수익화 달성',
        ],
        tools: ['Flutter', 'Unity3D', 'Figma', 'ChatGPT', 'Gemini', 'Claude'],
        environment: 'Android / iOS / Web',
      ),
      Career(
        period: '2025.09 ~ 2026.01',
        company: '(주)코드브릿지엑스',
        department: '개발팀',
        position: '연구원(팀원)',
        role: '제조 MES 및 ERP 시스템 UX/UI 설계 및 디자인·개발 협업 프로세스 혁신',
        projects: [
          '실시간 댓글 피드와 커뮤니케이션 기능을 내장한 온라인 기획서 플랫폼을 구축하여 기획-개발 간 소통 공정 일원화',
          'Figma 기반 High-Fidelity 반응형 프로토타입 설계를 도입하여 개발자 코드 커스터마이징 생산성 극대화',
          '디자인 토큰과 디자인 시스템 에셋을 모니터링하고 일관되게 제어하는 디자인 시스템 관리자 화면(Admin UI) 기획 및 개발',
          '프로세스 데이터 신뢰성 확보를 위한 단위/통합 테스트 기획 버전 검증 툴을 설계 및 개발하여 예외 리스크 사전 예방',
          '브랜드 아이덴티티 수립을 위한 CI/BI 리뉴얼 작업 및 서식류(명함 등) 비주얼 가이드라인 디자인',
        ],
        achievements: [
          '디자인-개발 공정 정합성 보장을 위한 Git 기반 형상 관리 및 버전 제어 프로세스 도입',
          'MES/ERP 시스템 디자인 개발 완성률 100% 및 마일스톤 일정 준수율 100% 달성',
        ],
        tools: const ['Figma', 'Git', 'Claude', 'Gemini', 'Midjourney', 'HTML/CSS/JS'],
        environment: 'Web / Windows',
      ),
      Career(
        period: '2025.01 ~ 2025.06',
        company: '아이엔지피플',
        department: 'UX팀',
        position: '매니저',
        role: '금융(보험) 및 공공 플랫폼 UX/UI 개발',
        projects: [
          'AIA생명 앱 고령자 모드 UX 기획 및 디자인 시스템 설계로 접근성 강화',
          '마사회 비즈온 앱, 토지개발 솔루션 등 복잡한 데이터 환경의 반응형 웹 UX 설계 주도',
        ],
        achievements: [
          '보험료 납입, 대출 상환 등 금융 핵심 GUI 가이드라인 수립',
        ],
        tools: ['Figma', 'MS Office'],
        environment: 'Android / iOS / Web',
      ),
      Career(
        period: '2018.05 ~ 2024.03',
        company: '현대에이치티(주)',
        department: 'GUX디자인팀',
        position: '수석연구원(팀장)',
        role: '스마트홈 IoT 솔루션 UX/UI 총괄 디렉팅 및 팀 리딩',
        projects: [
          '업계 1위 유지를 위한 HT 안드로이드 월패드 전 라인업(7~24인치) UX 설계 프로세스 체계화',
          '현대건설, 포스코건설, 대림산업 등 주요 건설사 맞춤형 월패드 GUI 총괄 및 디자인 시스템 일괄 적용',
          '스마트홈 앱(HT HOME 2.0 등) 론칭 및 월패드-웹-모바일 통합 연동 경험 최적화',
          '3D 요소 및 안면인식 기술 등을 적용한 차세대 로비폰/월패드 UX 선도',
        ],
        achievements: [
          'B2B 니즈와 B2C 사용성을 조화시킨 디자인 거버넌스 및 시스템 적용',
        ],
        tools: [
          'Figma',
          'Adobe XD',
          'Photoshop',
          'Illustrator',
          'Protopie',
          'Zeplin',
          'Lottie',
          'After Effects',
          'Jira',
          'Confluence',
          'Slack',
        ],
        environment: 'Android / iOS / Web',
      ),
      Career(
        period: '2016.05 ~ 2017.06',
        company: '(주)블루스톤소프트',
        department: '아트실',
        position: '책임연구원',
        role: '모바일 게임 SOULARK UX/UI 개발',
        projects: [
          '모바일 RPG 게임 SOULARK 인게임 GUI 최적화 구현 및 가이드라인 수립',
        ],
        achievements: [
          '게임 개발 마일스톤 준수 및 개발 프로세스 효율성 20% 향상 기여',
        ],
        tools: ['Photoshop', 'Illustrator', 'After Effects', 'Unity3D'],
        environment: 'Android / iOS (Unity3D)',
      ),
      Career(
        period: '2010.10 ~ 2015.12',
        company: '(주)넥슨코리아',
        department: 'PITBULL팀',
        position: '과장',
        role: '주요 모바일/PC 게임 타이틀 UX/UI 디자인 및 운영',
        projects: [
          '클로저스 CBT 사이트에 사내 최초 PC/모바일 반응형 웹 구현 적용',
          '피파온라인3, 카트라이더, 엘소드 등 넥슨 핵심 타이틀의 UX/UI 운영 리딩',
          '영웅시대30 인게임 GUI 리뉴얼 및 다수의 신규 프로젝트(PROJECT V, B 등) 리딩',
        ],
        achievements: [
          '주요 타이틀의 최적화를 통해 유저 리텐션 지수 향상 및 매출 기여',
        ],
        tools: ['Photoshop', 'Illustrator', 'After Effects', 'Unity3D', 'Flash'],
        environment: 'Android / iOS / Web',
      ),
      Career(
        period: '2008.07 ~ 2010.10',
        company: 'YNK(플레이위드)코리아',
        department: '웹팀',
        position: '파트장',
        role: '게임 서비스 웹사이트 및 플래시 기반 웹게임 UX/UI 개발',
        projects: [
          'Flash AS2.0 기반의 로한 시공의탑 웹게임 UX/UI 개발',
          'Full Flash 기반의 스팅 OBT 웹사이트 성공적 구축 및 씰온라인 리뉴얼',
        ],
        achievements: [
          '사내 신규 웹게임 조직 신설 기여 및 마케팅 유저 유입 상승 기여',
        ],
        tools: ['Photoshop', 'Illustrator', 'Flash (AS 2.0)', 'After Effects'],
        environment: 'Web',
      ),
      Career(
        period: '2008.03 ~ 2008.07',
        company: '비엠소프트',
        department: 'E스포츠사업부',
        position: '대리',
        role: '아마추어 게임 리그 플랫폼 UX/UI 기획 및 디자인',
        projects: [
          'WAPL 아마추어 게임 리그 웹사이트의 기획부터 디자인까지 전 과정 전담',
        ],
        achievements: [
          'WAPL 플랫폼의 성공적인 OBT 론칭 및 비즈니스 UI 운영 관리',
        ],
        tools: ['Photoshop', 'Illustrator', 'Flash'],
        environment: 'Web',
      ),
      Career(
        period: '2005.11 ~ 2006.12',
        company: '씨앤디',
        department: '인테리어사업부',
        position: '팀원',
        role: '웹사이트 UX/UI 개발 및 3D 공간 디자인',
        projects: [
          '3ds Max를 활용한 수준 높은 3D 공간 디자인 제작',
          '사업부별 웹사이트 UX/UI 개발 및 수주 활동 지원',
        ],
        achievements: [
          '가상 3D 공간 디자인 시안으로 실제 인테리어 계약 성사에 직접 기여',
        ],
        tools: ['Photoshop', 'Illustrator', '3D MAX'],
        environment: 'Web',
      ),
    ],
    coreCompetencies: const [
      '16년 11개월 차 UX/UI 전문가: 게임, 스마트홈(IoT), 금융, 공공 서비스 등 폭넓은 도메인 경험 보유',
      'Product Lead 역량: 대규모 프로젝트 리딩 및 디자인 시스템 구축을 통한 협업 효율성 극대화',
      '최신 기술 스택: Figma 중심 설계 및 AI 툴(Claude, Midjourney 등)을 활용한 업무 생산성 혁신',
      '실행력 및 비즈니스 성과: 출시 2개월 내에 앱 2종 누적 다운로드 각각 400건 돌파 및 수익화 구조 실현',
      '신뢰 기반의 프로세스: 전 프로젝트 일정 준수율 100% 및 디자인 개발 완성률 100% 달성',
    ],
    certifications: const [
      Certification(name: '유통관리사', issuer: '대한상공회의소', date: '2006.11'),
      Certification(name: '시각디자인산업기사', issuer: '산업인력공단', date: '2006.05'),
      Certification(name: '워드프로세서 1급', issuer: '대한상공회의소', date: '2006.02'),
      Certification(name: '(국가공인)인터넷정보검색사 2급', issuer: '한국정보통신인력개발센터', date: '2000.02'),
      Certification(name: '자동차운전면허', issuer: '고양경찰서장', date: '1999.11'),
    ],
  );
});

final coverLetterProvider = Provider<CoverLetterModel>((ref) {
  return const CoverLetterModel(
    id: 'coverletter_1',
    greeting:
        '인사말: 풍부한 실무 구력으로 비즈니스와 사용자를 잇는 \'디자인 브릿지\'\n\n기획의 본질을 이해하고, 개발자와 완벽하게 소통하며, 마켓 론칭까지 스스로 책임질 수 있는 프로덕트 디자이너 정재웅입니다. 게임, 스마트홈(IoT), 금융, 공공 서비스 등 다양한 도메인을 거치면서 Web과 Mobile은 물론 전용 단말기까지 플랫폼의 제약 없는 실무 설계 역량을 탄탄히 쌓아왔습니다.\n\n최근에는 Claude, Midjourney 등 AI 도구를 실무 파이프라인에 적극 도입하여 리소스 제작 공정을 혁신하고 있으며, Flutter 기반의 1인 풀스택 개발까지 아우르며 개발 공정을 완벽히 이해하고 리딩하는 협업 최적화 인재로 성명해 내고 있습니다.',
    background:
        '성장과정: 3D의 디테일에서 UX의 논리로\n\n어릴 적부터 애니메이션과 게임에 매료되어 3D 애니메이션을 전공하며 시각적 표현의 깊이를 익혔습니다. 실무에 입문한 후, 화려한 그래픽보다 사용자의 니즈를 정의하고 흐름을 설계하는 기획적 사고에 더 큰 매력을 느꼈습니다. 이러한 배경은 제가 단순히 화면을 그리는 디자이너가 아니라, 제품 전체의 구조와 사용자 경험을 함께 고민하는 프로덕트 디자이너로 성장하는 탄탄한 밑거름이 되었습니다.',
    personality:
        '성격 및 장점: 100%의 신뢰를 담보하는 책임감과 유연성\n\n저의 가장 큰 자산은 \'프로젝트 일정 준수율 100%\'라는 기록이 증명하는 강력한 책임감입니다. 촉박한 일정이나 예기치 못한 변수 속에서도 단 한 번의 중도도 이탈 없이 결과물을 만들어왔습니다. 또한, 오랜 시간 동안 Flash에서 Figma로, 다시 AI 기반 프로세스로 변화하는 프로세스를 스스로 학습하고 즐기는 유연함을 갖추고 있습니다. 동료들에게는 신뢰를, 조직에는 안정적인 성과를 제공하는 것이 저의 원칙입니다.',
    hobbies:
        '핵심역량: 데이터 기반 UX 설계와 통합 디자인 시스템 구축\n\n플랫폼 통합 설계 역량: 스마트홈 월패드부터 AIA생명 금융 앱까지, 복잡한 사용자 여정을 직관적으로 구조화하는 User Flow 및 Flow Chart 설계에 능숙합니다.\n\n디자인 시스템 수립: 현대에이치티 재직 시, 전사적인 디자인 가이드라인과 시스템을 구축하여 다수의 라인업에 일괄 적용함으로써 작업 효율과 브랜드 일관성을 확보했습니다.\n\n기술 융합 및 확장성: Figma, Unity3D, Blender 등을 활용한 입체적 GUI 구현이 가능하며, 최신 AI 기술을 활용해 프로토타이핑 속도를 혁신적으로 단축합니다.',
    aspiration:
        '입사 후 포부: 경력을 넘어 성과로 증명하는 프로페셔널\n\n귀사에 합류한다면 저의 풍부한 실무 경험을 바탕으로 비즈니스 목표를 가장 효율적으로 달성할 수 있는 디자인 솔루션을 제시하겠습니다. 관리 업무에 치중하기보다 현장에서 직접 발로 뛰며, 기획 및 개발 파트와 기민하게 소통하여 제품의 완성도를 끌어올리는 핵심 실무자의 역할을 수행하겠습니다. 지금까지 쌓아온 전문성이 귀사의 서비스 성장으로 직결될 수 있도록, 결과물로 그 가치를 증명했습니다.',
  );
});
