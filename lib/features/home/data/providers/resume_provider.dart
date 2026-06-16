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
        period: '2025.10 ~ 2026.01',
        company: '(주)코드브릿지엑스',
        department: '개발팀',
        position: '팀원',
        role: '기업용 시스템 UX/UI 기획 및 화면 디자인 개발 / AI 활용 프로세스 효율화',
        projects: [
          '제조 MES 및 ERP 시스템 UX/UI 기획 및 화면 디자인 개발',
          'AI 활용 디자인 프로세스 효율성 극대화 (Claude, Gemini, Midjourney 도입)',
          'Figma 기반 디자인 시스템 구축 및 Hi-Fi 프로토타입 제작 주도',
        ],
        achievements: [
          '방대한 MES/ERP 데이터를 직관적으로 구조화 및 시각화하여 사용성 극대화',
          '최신 생성형 AI 툴을 디자인 리서치 및 에셋 제작 프로세스에 선제적으로 적용하여 작업 공수 대폭 단축',
          'Figma 기반 디자인 시스템 표준화로 개발 협업 효율 혁신',
        ],
        tools: ['Figma', 'Claude', 'Gemini', 'Midjourney'],
        resignationReason: '계약 만료',
      ),
      Career(
        period: '2025.01 ~ 2025.06',
        company: '아이엔지피플 (INGPPL)',
        department: 'UX팀',
        position: '팀원',
        role: 'Senior Product Designer / UX UI 기획 및 설계 실무 리딩',
        projects: [
          'AIA생명 AIA+ : 고령자 특화 모드(Senior Mode) UX/UI 고도화 개발 | 2025.02-2025.06',
          '한국 마사회 비즈온(BizOn) 앱 UX/UI 전략 수립 및 제안 개발 | 2025.02',
          '데이터개발 분석 솔루션 반응형 UX/UI 기획 및 설계 | 2025.01-2025.02',
        ],
        achievements: [
          '디자인 개발 완성도 100%, 프로젝트 일정 준수율 100% 달성',
          'AIA 생명 Phase2 고령자 모드 메인 UX 기획 및 디자인 시스템 구축',
          '보험료 납입, 보험계약대출 상환 등 복잡한 금융 프로세스 고령자 관점에서 단순화하여 이탈률 최적화 기여',
          '데이터 기반 원격 분석 플랫폼의 복잡한 그리드 시스템을 반응형으로 재설계하여 정보 가독성 극대화',
        ],
        tools: ['Figma', 'MS Office'],
        resignationReason: '계약 만료',
      ),
      Career(
        period: '2018.05 ~ 2024.03',
        company: '현대에이치티 (Hyundai HT)',
        department: 'GUX디자인팀',
        position: '팀장 (수석연구원)',
        role: 'UX/UI Product Design Lead / 스마트홈 에코시스템 UX 총괄',
        projects: [
          '세계 최초 24인치 대화면 안드로이드 월패드(범용) UX/UI 핵심 설계',
          '포스코 / 대우 / 현대건설 등 Major 건설사향 월패드 UX 커스터마이징 전략 수립',
          'HT HOME 2.0 및 IoT 통합 앱 UX/UI 고도화 및 리브랜딩 리딩',
          'PSQC(포스코 스마트 시티 솔루션) 앱 플랫폼 UX/UI 설계',
        ],
        achievements: [
          '스마트홈 업계 1위를 공고히 하는 7인치~24인치 멀티 디바이스 통합 디자인 시스템(Design System) 구축',
          '안드로이드 기반의 주거용 월패드 UI를 현대적인 UX 디자인으로 전면 교체하여 사용자 만족도 및 제품 경쟁력 강화',
          '복잡다단한 IoT 기기(조명, 가전, 환기 등) 제어 동선을 직관적인 개인화 제어로 재설계하여 사용성 지수 개선',
          'B2B(건설사) 니즈와 B2C(입주자) 사용성을 동시에 만족시키는 하이브리드 UX 전략으로 업계 표준 주도',
        ],
        tools: [
          'Figma',
          'Adobe XD',
          'Photoshop/Illustrator',
          'Protopie',
          'Zeplin',
          'Lottie/After Effects',
          'Jira/Confluence/Slack',
        ],
        environment: 'Android (Custom Rom) / iOS / Web',
        resignationReason: '휴식 (건강악화)',
      ),
      Career(
        period: '2016.05 ~ 2017.06',
        company: '블루스톤소프트',
        department: '아트팀',
        position: '차장',
        role: 'UX/UI Lead / 모바일 게임 인터페이스 아키텍처 및 제작 총괄',
        projects: ['SOULARK(소울아크) 모바일 RPG 게임 UX/UI 개발 전담'],
        achievements: [
          'RPG 게임 고유의 복잡한 성장/강화 시스템 UX를 사용자 인지 단계에 맞춰 재설계하여 학습 곡선 단축',
          '디자인 에셋 관리 규격화 및 컴포넌트화를 통해 개발-디자인 간 생산성 30% 이상 기여',
          'Unity3D 환경에서의 최적화된 GUI 가이드라인 수립하여 마일스톤 주요 목표 100% 달성',
        ],
        tools: ['Photoshop', 'Illustrator', 'After Effects', 'Unity3D'],
        environment: 'Android / iOS (Unity3D)',
        resignationReason: '개발환경 변경',
      ),
      Career(
        period: '2010.10 ~ 2016.01',
        company: '넥슨코리아 (NEXON Korea)',
        department: 'PITBULL팀',
        position: '과장',
        role: 'UX/UI Designer / PC 및 모바일 게임 통합 UX 디자인',
        projects: [
          '클로저스 (Closers) CBT 및 공식 사이트 반응형 UX/UI 디자인',
          '넥슨 아레나 경기장 전시 캐릭터 인터랙션 전용 앱 UX/UI 개발',
          '카트라이더 / 에어라이더 / 버블파이터 등 포털 및 게임 UX/UI 운영 및 고도화',
          'Project B/V/OX 등 신규 모바일 프로젝트 초기 UX 컨셉 수립',
        ],
        achievements: [
          '국내 최초 클로저스 사이트의 데스크탑/태블릿/모바일 통합 반응형 설계 적용하여 사용자 접근성 혁신',
          '넥슨 아레나 전용 앱을 통해 오프라인 관람객 경험을 통합하는 인터랙티브 UX 사례 확보',
          '게임 및 프로모션 디자인 최적화를 통해 신규 유입량 및 전환 지수(CVR) 상승에 직접적 기여',
        ],
        tools: [
          'Photoshop',
          'Illustrator',
          'After Effects',
          'Unity3D',
          'Flash (AS 3.0)',
        ],
        environment: 'Android / iOS (Unity3D) / Web',
        resignationReason: '조직개편',
      ),
      Career(
        period: '2008.07 ~ 2010.10',
        company: 'YNK코리아 (플레이위드)',
        department: '디자인팀',
        position: '대리',
        role: 'UX/UI Designer / 브랜딩 및 플랫폼 아키텍처 수립',
        projects: [
          '로한 천공의 성 포털 및 인게임 UX/UI 개발',
          '스팅 (STING) OBT 사이트 및 브랜드 플랫폼 설계',
        ],
        achievements: [
          'Flash AS2.0 기반의 고도화된 UI 애니메이션 기술로 당시 업계 UI 기술의 한계를 돌파',
          '브랜드 아이덴티티와 연동된 강렬한 비주얼 임팩트로 신규 게임 홍보 및 유입 핵심 역할 수행',
        ],
        tools: ['Photoshop', 'Illustrator', 'Flash (AS 2.0)', 'After Effects'],
        environment: 'Web',
        resignationReason: '경영악화 (구조조정)',
      ),
      Career(
        period: '2008.03 ~ 2008.07',
        company: '(주)비엠소프트',
        department: '디자인팀',
        position: '대리',
        role: '플랫폼 UX/UI 기획 및 디자인 개발',
        projects: [
          '아마추어 게임 리그 플랫폼 WAPL 웹사이트 UX/UI 설계 및 기획',
          '비즈니스 모델 맞춤형 UI 디자인 고도화 및 플랫폼 운영 관리',
        ],
        achievements: [
          '기획 단계부터 주도적으로 참여하여 복잡한 토너먼트 및 리그 데이터를 직관적인 UX/UI로 시각화',
          'BM 최적화 디자인 개선으로 플랫폼의 안정적 시장 안착에 기여',
        ],
        tools: ['Photoshop', 'Illustrator', 'Flash'],
        resignationReason: '이직',
      ),
      Career(
        period: '2005.12 ~ 2006.12',
        company: '(주)씨앤디',
        department: '디자인팀',
        position: '사원',
        role: 'UX/UI 개발 및 3D 공간 설계',
        projects: [
          '인테리어 및 스포츠 사업부 웹사이트 UX/UI 설계 및 디자인',
          '3D MAX를 활용한 인테리어 공간 디자인 개발',
          '사업부별 프로모션 및 웹 페이지 그래픽 디자인',
        ],
        achievements: [
          '3D MAX를 통한 공간 디자인으로 프로젝트 설계 계약 성사에 기여',
          '시각 및 공간 설계를 융합한 핵심 프로젝트 수주 기여',
        ],
        tools: ['Photoshop', 'Illustrator', '3D MAX'],
        resignationReason: '이직',
      ),
    ],
    coreCompetencies: const [
      '20년의 실무 경력을 바탕으로 복잡한 비즈니스 요구사항을 명확한 UX 아키텍처와 장인정신이 담긴 UI로 구현하는 실무 역량',
      'AI 시대의 선두에서 Gemini, Claude, ChatGPT 등 LLM과 Midjourney를 실무 디자인 워크플로우에 통합하여 생산성을 혁신하는 AI 리서치 역량',
      'Antigravity(Agentic Workflow)를 포함한 최신 AI 에이전트 기술을 연구하고, 이를 UX 설계 및 디자인 프로세스 자동화에 적용하는 미래 지향적 시도',
      '7인치부터 24인치까지 다양한 하드웨어 환경에서 최적의 사용성을 구현해내는 스마트 디바이스 설계 및 디자인 시스템 구축 전문가',
      '단 한 번의 일정 지연이나 중도 이탈 없이 모든 프로젝트를 성공적으로 완수해온 책임감과 실행 중심의 실무 리딩 역량',
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
        '17년 구력으로 비즈니스 가치를 높이는 디자인 브릿지\n\n단순히 보기 좋은 디자인을 넘어, 정보의 본질을 명확하게 전달하고 비즈니스 지표를 개선하는 데 집중해 왔습니다. 넥슨코리아와 같은 대형 게임사부터 현대에이치티의 IoT 솔루션, 그리고 최근의 핀테크 서비스까지 다양한 산업군을 거치며 Web, Mobile(Android/iOS), 전용 단말기(월패드) 등 플랫폼의 제약 없는 설계 역량을 쌓았습니다.\n\n최근에는 Claude, Midjourney 등 AI 도구를 실무 프로세스에 적극 도입하여 제작 효율성을 극대화하고 있으며, Flutter 학습을 병행하여 개발 공정을 완벽히 이해하는 \'협업에 최적화된 디자이너\'로 끊임없이 진화하고 있습니다. 대규모 트래픽과 B2B/B2C를 모두 아우른 경험을 바탕으로 귀사의 서비스 안정화와 성장에 즉각적으로 기여하겠습니다.',
    background:
        '3D 그래픽의 디테일에서 인터랙션 UX의 논리로\n\n어릴 적부터 애니메이션과 게임의 연출에 매료되어 애니메이션학과에 진학했고, 3D 그래픽과 애니메이션을 전공하며 시각적 표현의 깊이와 디테일을 익혔습니다. 졸업 후 실무에 입문하면서, 화면을 화려하게 채우는 것보다 \'사용자의 숨겨진 니즈를 정의하고 최적의 흐름을 설계하는 기획적 사고\'에 더 큰 매력을 느끼게 되었습니다.\n\n이러한 그래픽적 베이스와 기획적 사고의 융합은 제가 단순히 지시사항을 그리는 디자이너에 머무르지 않고, 제품 전체의 기술적 타당성과 구조적 사용자 경험을 함께 고민하는 프로덕트 디자이너로 성장하는 탄탄한 밑거름이 되었습니다.',
    personality:
        '데이터 기반 UX 설계와 통합 디자인 시스템 구축 역량\n\n저의 핵심 역량은 크게 세 가지로 요약됩니다. 첫째, 플랫폼 통합 설계 역량입니다. 스마트홈 월패드부터 AIA생명 금융 앱까지, 복잡한 사용자 여정을 직관적으로 구조화하는 User Flow 및 Flow Chart 설계에 능숙합니다.\n\n둘째, 디자인 시스템 정립입니다. 현대에이치티 재직 시, 전사적인 디자인 가이드라인과 글로벌 시스템을 구축하여 다수의 라인업에 일괄 적용함으로써 작업 효율과 브랜드 일관성을 동시에 확보했습니다.\n\n셋째, 기술 융합과 확장성입니다. Figma, Unity3D, Blender 등을 활용한 입체적 GUI 구현이 가능하며, 최신 생성형 AI 기술을 활용해 프로토타이핑 속도를 혁신적으로 단축하는 트렌디함을 유지하고 있습니다.',
    hobbies:
        '일정 준수율 100%의 책임감과 기술적 유연성\n\n저의 가장 큰 자산은 \'프로젝트 일정 준수율 100%\'라는 기록이 증명하는 강력한 책임감입니다. 촉박한 론칭 일정이나 예기치 못한 환경적 변수 속에서도 단 한 번의 중도 이탈 없이 완성도 높은 결과물을 만들어왔습니다. 또한, 17년이라는 긴 시간 동안 Flash에서 Figma로, 다시 AI 기반의 프로세스로 급변하는 기술 트렌드를 스스로 학습하고 즐기는 유연함을 갖추고 있습니다.\n\n단점으로는 완벽한 완성도를 추구하느라 기획 검토 단계에서 많은 공수를 들이는 편이지만, Figma 컴포넌트 표준화와 AI 툴을 적극 도입해 제작 공수를 획기적으로 줄임으로써 속도와 품질을 동시에 완벽히 통제하고 있습니다.',
    aspiration:
        '성과로 존재 가치를 증명하는 핵심 프로덕트 디자이너\n\n귀사에 합류한다면 17년간 쌓아온 폭넓은 실무 경험과 통찰력을 바탕으로, 비즈니스 목표를 가장 빠르고 효율적으로 달성할 수 있는 UI/UX 솔루션을 제시하겠습니다. 연차에 기대어 관리 업무에만 치중하기보다, 현장에서 직접 발로 뛰며 Figma 스펙을 정교화하고 기획 및 개발 파트와 기민하게 소통하는 \'대체 불가능한 핵심 실무자\'의 역할을 수행하겠습니다.\n\n비즈니스와 개발 프로세스를 모두 이해하는 디자이너로서, 제 전문성이 귀사 서비스의 가시적인 지표 개선과 전환율 상승으로 직결될 수 있도록 매 순간 결과물로 그 가치를 증명하겠습니다.',
  );
});
