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
      militaryService: '육군 병장 만기전역 (1999.11 ~ 2002.01)',
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
        major: '애니메이션과 사진·만화 전공 졸업',
        gpa: '(3.34/4.0)',
      ),
    ],
    careers: const [
      Career(
        period: '2026.01 ~ 현재',
        company: 'Independent Projects (Personal)',
        department: 'Personal',
        position: '1인 개발',
        role: '글로벌 22개국 타겟 서비스 및 게이미피케이션 앱 6종 기획·개발·런칭',
        projects: [
          'Flutter 및 Unity를 활용하여 기획부터 디자인, 개발, 마켓 런칭까지 전 과정 수행',
          '22개국 다국어 로컬라이징 지원 및 AI 기반 콘텐츠 분석 시스템 구축',
        ],
        achievements: [
          '단기간 내 글로벌 마켓 런칭을 통한 유저 유입 및 수익화 구조(광고/결제) 실현',
        ],
        tools: ['Flutter', 'Unity3D', 'Figma'],
        environment: 'Android / iOS',
      ),
      Career(
        period: '2025.09 ~ 2026.01',
        company: '(주)코드브릿지엑스',
        department: '개발팀',
        position: '연구원(팀원)',
        role: '제조 MES + ERP 시스템 UX/UI 고도화',
        projects: [
          'Claude, Gemini, Midjourney 등 AI 툴을 실무에 도입하여 기획 및 리소스 제작 속도 개선',
          'Figma 기반의 고도화된 디자인 시스템 및 Hi-Fi 프로토타입 제작으로 개발팀과의 소통 비용 최소화',
        ],
        achievements: [
          '디자인 개발 완성률 및 프로젝트 일정 준수율 100% 달성',
        ],
        tools: ['Figma', 'Claude', 'Gemini', 'Midjourney'],
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
      '18년 차 UX/UI 전문가: 게임, 스마트홈(IoT), 금융, 공공 서비스 등 폭넓은 도메인 경험 보유',
      'Product Lead 역량: 대규모 프로젝트 리딩 및 디자인 시스템 구축을 통한 협업 효율성 극대화',
      '최신 기술 스택: Figma 중심 설계 및 AI 툴(Claude, Midjourney 등)을 활용한 업무 생산성 혁신',
      '실행력 및 비즈니스 성과: 퇴사 후 2개월 내 6종의 앱 기획·개발·런칭 및 수익화 달성',
      '신뢰 기반의 프로세스: 전 프로젝트 일정 준수율 100% 및 디자인 개발 완성률 100% 달성',
    ],
    certifications: const [
      Certification(name: '시각디자인산업기사', issuer: '한국산업인력공단', date: '2006.05'),
      Certification(name: '유통관리사 2급', issuer: '대한상공회의소', date: '2006.11'),
      Certification(name: '워드프로세서 1급', issuer: '대한상공회의소', date: '2006.02'),
    ],
  );
});

final coverLetterProvider = Provider<CoverLetterModel>((ref) {
  return const CoverLetterModel(
    id: 'coverletter_1',
    greeting:
        '18년 구력으로 비즈니스 가치를 높이는 디자인 브릿지\n\n단순히 보기 좋은 디자인을 넘어, 정보의 본질을 명확하게 전달하고 비즈니스 지표를 개선하는 데 집중해 왔습니다. 넥슨코리아와 같은 대형 게임사부터 현대에이치티의 IoT 솔루션, 그리고 최근의 핀테크 서비스까지 다양한 산업군을 거치며 Web, Mobile(Android/iOS), 전용 단말기(월패드) 등 플랫폼의 제약 없는 설계 역량을 쌓았습니다.\n\n최근에는 Claude, Midjourney 등 AI 도구를 실무 프로세스에 적극 도입하여 제작 효율성을 극대화하고 있으며, Flutter 학습을 병행하여 개발 공정을 완벽히 이해하는 \'협업에 최적화된 디자이너\'로 끊임없이 진화하고 있습니다. 대규모 트래픽과 B2B/B2C를 모두 아우른 경험을 바탕으로 귀사의 서비스 안정화와 성장에 즉각적으로 기여하겠습니다.',
    background:
        '3D 그래픽의 디테일에서 인터랙션 UX의 논리로\n\n어릴 적부터 애니메이션과 게임의 연출에 매료되어 애니메이션학과에 진학했고, 3D 그래픽과 애니메이션을 전공하며 시각적 표현의 깊이와 디테일을 익혔습니다. 졸업 후 실무에 입문하면서, 화면을 화려하게 채우는 것보다 \'사용자의 숨겨진 니즈를 정의하고 최적의 흐름을 설계하는 기획적 사고\'에 더 큰 매력을 느끼게 되었습니다.\n\n이러한 그래픽적 베이스와 기획적 사고의 융합은 제가 단순히 지시사항을 그리는 디자이너에 머무르지 않고, 제품 전체의 기술적 타당성과 구조적 사용자 경험을 함께 고민하는 프로덕트 디자이너로 성장하는 탄탄한 밑거름이 되었습니다.',
    personality:
        '데이터 기반 UX 설계와 통합 디자인 시스템 구축 역량\n\n저의 핵심 역량은 크게 세 가지로 요약됩니다. 첫째, 플랫폼 통합 설계 역량입니다. 스마트홈 월패드부터 AIA생명 금융 앱까지, 복잡한 사용자 여정을 직관적으로 구조화하는 User Flow 및 Flow Chart 설계에 능숙합니다.\n\n둘째, 디자인 시스템 정립입니다. 현대에이치티 재직 시, 전사적인 디자인 가이드라인과 글로벌 시스템을 구축하여 다수의 라인업에 일괄 적용함으로써 작업 효율과 브랜드 일관성을 동시에 확보했습니다.\n\n셋째, 기술 융합과 확장성입니다. Figma, Unity3D, Blender 등을 활용한 입체적 GUI 구현이 가능하며, 최신 생성형 AI 기술을 활용해 프로토타이핑 속도를 혁신적으로 단축하는 트렌디함을 유지하고 있습니다.',
    hobbies:
        '일정 준수율 100%의 책임감과 기술적 유연성\n\n저의 가장 큰 자산은 \'프로젝트 일정 준수율 100%\'라는 기록이 증명하는 강력한 책임감입니다. 촉박한 론칭 일정이나 예기치 못한 환경적 변수 속에서도 단 한 번의 중도 이탈 없이 완성도 높은 결과물을 만들어왔습니다. 또한, 18년이라는 긴 시간 동안 Flash에서 Figma로, 다시 AI 기반의 프로세스로 급변하는 기술 트렌드를 스스로 학습하고 즐기는 유연함을 갖추고 있습니다.\n\n단점으로는 완벽한 완성도를 추구하느라 기획 검토 단계에서 많은 공수를 들이는 편이지만, Figma 컴포넌트 표준화 and AI 툴을 적극 도입해 제작 공수를 획기적으로 줄임으로써 속도와 품질을 동시에 완벽히 통제하고 있습니다.',
    aspiration:
        '성과로 존재 가치를 증명하는 핵심 프로덕트 디자이너\n\n귀사에 합류한다면 18년간 쌓아온 폭넓은 실무 경험과 통찰력을 바탕으로, 비즈니스 목표를 가장 빠르고 효율적으로 달성할 수 있는 UI/UX 솔루션을 제시하겠습니다. 연차에 기대어 관리 업무에만 치중하기보다, 현장에서 직접 발로 뛰며 Figma 스펙을 정교화하고 기획 및 개발 파트와 기민하게 소통하는 \'대체 불가능한 핵심 실무자\'의 역할을 수행하겠습니다.\n\n비즈니스와 개발 프로세스를 모두 이해하는 디자이너로서, 제 전문성이 귀사 서비스의 가시적인 지표 개선과 전환율 상승으로 직결될 수 있도록 매 순간 결과물로 그 가치를 증명하겠습니다.',
  );
});
