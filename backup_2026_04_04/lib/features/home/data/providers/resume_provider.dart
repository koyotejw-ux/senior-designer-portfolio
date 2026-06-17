import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_model.dart';

final resumeProvider = Provider<ResumeModel>((ref) {
  return ResumeModel(
    id: 'resume_1',
    photoUrl: 'http://localhost:8080/images/profile_photo.jpg',
    personalInfo: const PersonalInfo(
      name: '정재웅',
      birthDate: '1979. 08. 14',
      address: '경기도 고양시 덕양구 향동동',
      militaryService: '육군 병장 전역 (1999년11월 ~ 2002년1월)',
      phone: '010-4375-3599',
      email: 'coyotejw@naver.com',
    ),
    education: const [
      Education(
        period: '2006.08 ~ 2008.02',
        institution: '학점은행제',
        major: '시각디자인학과 졸업',
        gpa: '(4.25/4.5)',
      ),
      Education(
        period: '1999.03 ~ 2004.02',
        institution: '청강문화산업대학교',
        major: '애니메이션과 3D전공(주간) 졸업',
        gpa: '(3.34/4.2)',
      ),
    ],
    careers: const [
      Career(
        period: '2025.01 ~ 2025.06',
        company: '아이엔지피플 (INGPPL)',
        department: 'UX팀',
        position: '매니저',
        role: 'Senior Product Designer / UX UI 기획 및 설계 실무 리딩',
        projects: [
          'AIA생명 앱 : 고령자 모드 UX/UI 고도화 개발 | 2025.02-2025.06',
          '한국 마사회 비즈온 앱 UX/UI 시안 개발 | 2025.02',
          '토지개발 분석 솔루션 반응형 웹 UX/UI 개발 | 2025.01-2025.02',
        ],
        achievements: [
          '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성',
          'AIA 생명 Phase2 고령자 모드 메인 UX 기획 및 디자인 시스템 구축',
          '보험료 납입, 보험계약대출 상환, 자동부활 신청 등 핵심 GUI 정의',
          '토지개발 분석 플랫폼 UX/UI 기획 및 디자인 방향 수립, 디자인 시스템 설계',
        ],
        tools: ['Figma', 'MS Office'],
        resignationReason: '휴식 (교통사고 후 회복 완료)',
      ),
      Career(
        period: '2018.05 ~ 2024.02',
        company: '현대에이치티 (Hyundai HT)',
        department: 'GUX디자인팀',
        position: '수석연구원',
        role: 'Product Lead / 스마트홈 시스템 UX 설계 및 디자인 실무 총괄',
        projects: [
          'HT 범용 24인치 안드로이드 월패드 UX/UI 개발 총괄',
          '포스코건설/현대건설/현대엔지니어링 전용 안드로이드 월패드(7~13.3인치) UX/UI 개발',
          'HT HOME 2.0 및 IoT 앱 UX/UI 고도화 리딩',
          'PSQC (포스코 더샵 퀄리티 컨트롤) 시운전 솔루션 웹사이트 UX/UI 개발',
          '대림산업/금호건설/한양건설/한화건설 전용 월패드 UX/UI 커스터마이징 리딩',
        ],
        achievements: [
          '국내 스마트홈 업계 1위 유지의 기반이 되는 HT 월패드 라인업 UX 설계 및 디자인 프로세스 구축',
          '고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 디자인 시스템 직접 설계 및 적용',
          'HT HOME 및 HT Imazu 앱 앱스토어 론칭 및 사용자 접점 확대 주도',
          '입주민용 웹사이트 반응형 설계 및 월패드/앱과의 통합 유기적 연동 최적화',
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
        department: '아트실',
        position: '책임연구원',
        role: 'UX/UI Designer / 모바일 게임 인터페이스 설계 및 실무 제작',
        projects: ['SOULARK 모바일 게임 UX/UI 개발'],
        achievements: [
          '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성',
          '개발 프로세스 효율성 30% 향상 (자료 규격화 및 컴포넌트화)',
          '마일스톤 주요 목표 전 항목 100% 달성',
        ],
        tools: ['Photoshop', 'Illustrator', 'After Effects', 'Unity3D'],
        environment: 'Android / iOS (Unity3D)',
        resignationReason: '개발환경',
      ),
      Career(
        period: '2010.10 ~ 2015.12',
        company: '넥슨코리아 (NEXON)',
        department: 'PITBULL팀',
        position: '과장',
        role: 'UX/UI Designer / PC 및 모바일 게임 UX 실무 디자인',
        projects: [
          'Project B/V/OX 모바일 게임 UX/UI 개발',
          '클로저스 CBT 반응형 웹사이트 및 공식 웹사이트 UX/UI 디자인',
          '넥슨 아레나 경기장 전용 앱 UX/UI 개발',
          '카트라이더 / 크레이지아케이드 / 엘소드 등 라이브 게임 UX/UI 디자인 운영',
          '영웅시대30 MMORPG 인게임 GUI 리뉴얼 및 웹사이트 개발',
        ],
        achievements: [
          '사내 최초 클로저스 CBT 웹사이트에 PC/태블릿/모바일 반응형 웹 구현 적용',
          '다양한 게임 프로모션 디자인을 통해 유저 유입률 및 매출 상승 직접 기여',
          '영웅시대30 인게임 GUI 리뉴얼 및 성공적 론칭 디자인 주도',
        ],
        tools: [
          'Photoshop',
          'Illustrator',
          'After Effects',
          'Unity3D',
          'Flash (AS 3.0)',
        ],
        environment: 'Android / iOS (Unity3D) / Web',
        resignationReason: '조직해체',
      ),
      Career(
        period: '2008.07 ~ 2010.10',
        company: 'YNK (플레이위드) 코리아',
        department: '웹팀',
        position: '대리',
        role: 'UX/UI Designer / 게임 브랜드 웹 플랫폼 설계 및 제작',
        projects: [
          '로한 시공의탑 웹게임(Flash AS2.0) UX/UI 개발',
          '스팅 마이크로/OBT 신규 웹사이트(Full Flash) UX/UI 개발',
          '로한/배틀로한/씰온라인 웹사이트 UX/UI 디자인 운영',
        ],
        achievements: [
          'Flash AS2.0 기반 고수준 UX/UI 디자인으로 웹게임 구현 및 신규 조직 신설 기여',
          '다양한 프로모션을 통한 유저 유입률 및 매출 증가 기여',
        ],
        tools: ['Photoshop', 'Illustrator', 'Flash (AS 2.0)', 'After Effects'],
        environment: 'Web',
        resignationReason: '경영악화 (구조조정)',
      ),
      Career(
        period: '2008.03 ~ 2008.07',
        company: '비엠소프트 (BM Soft)',
        department: 'E스포츠사업부',
        position: '대리',
        role: 'UX/UI Designer / 게임 리그 플랫폼 디자인 및 개발 보조',
        projects: ['WAPL 아마추어 게임 리그 웹사이트 UX/UI 기획 및 개발', 'WAPL 비즈니스 디자인 운영'],
        achievements: ['WAPL 아마추어 게임 리그 웹사이트 기획 및 성공적 론칭'],
        tools: ['Photoshop', 'Illustrator', '3DMAX', 'After Effects', 'Flash'],
        environment: 'Web',
        resignationReason: '경영악화 (폐업)',
      ),
      Career(
        period: '2005.11 ~ 2006.12',
        company: '씨앤디 (C&D)',
        department: '인테리어사업부',
        position: '팀원',
        role: '3D Artist & UX/UI Designer',
        projects: ['인테리어/스포츠 사업부 웹사이트 UX/UI 개발', '인테리어 설계 3D 공간 디자인 개발'],
        achievements: ['인테리어 3D 공간 디자인 제작을 통한 실계약 성사 기여', '웹사이트 수주를 통한 매출 기여'],
        tools: ['Photoshop', 'Illustrator', '3DMAX', 'Flash', 'PHP'],
        environment: 'Web',
        resignationReason: '경영악화 (폐업)',
      ),
    ],
    coreCompetencies: const [
      '20년의 실무 경력을 바탕으로 복잡한 비즈니스 요구사항을 명확한 UX 아키텍처와 장인정신이 담긴 UI로 구현하는 실무 역량',
      'AI 시대의 선두에서 Gemini, Claude, ChatGPT 등 LLM과 Midjourney를 실무 디자인 워크플로우에 통합하여 생산성을 혁신하는 AI 리서치 역량',
      'Antigravity(Agentic Workflow)를 포함한 최신 AI 에이전트 기술을 연구하고, 이를 UX 설계 및 디자인 프로세스 자동화에 적용하는 미래 지향적 태도',
      '7인치부터 24인치까지 다양한 하드웨어 환경에서 최적의 사용성을 구현해내는 크로스 디바이스 설계 및 디자인 시스템 구축 전문가',
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
        '직함이 주는 권위보다 실무 현장에서 픽셀 하나를 고민하는 장인정신에 더 큰 가치를 두는 20년 차 디자이너, 정재웅입니다. 저는 화려한 전략 수립에 그치지 않고, 그 전략을 직접 손으로 시각화하고 구현해내는 실무형 전문가를 지향합니다. 특히 AI 시대를 맞이하여 Gemini, Claude, ChatGPT, Midjourney 등 최신 AI 도구들을 단순한 도구 이상으로 연구하고 실무에 깊숙이 접목해왔습니다. 최근에는 Antigravity와 같은 Agentic 기술을 디자인 워크플로우에 어떻게 녹여낼 수 있을지 끊임없이 실험하며, 기술과 디자인이 융합된 새로운 시대에 가장 적합한 실무 인재가 되고자 노력하고 있습니다.',
    background:
        '어릴 때부터 그림과 3D 애니메이션에 몰두하며 축적해온 시각적 디테일에 대한 고집은, 지난 20년 동안 UX/UI 현장을 누비며 탄탄한 실전 근육으로 변모했습니다. 저는 지시하는 사람이기보다 현장에서 동료들과 함께 발을 맞추며 결과물을 만들어낼 때 가장 빛나는 플레이어입니다. 변화하는 파도 속에서 도태되지 않기 위해 언제나 최신 기술을 가장 먼저 익히고 실무에 적용해왔으며, 현재는 AI 기술 리서치를 통해 디자인 프로세스의 혁신을 직접 주도하고 있습니다.',
    personality:
        '동료들에게 "가장 신뢰할 수 있는 파트너"로 기억되는 비결은 변치 않는 성실함입니다. 프로젝트 과정의 수많은 변수 속에서도 단 한 번의 중도 포기나 일정 지연 없이 과업을 완수해온 것은 저의 실력보다 책임감 덕분이었습니다. 새로운 기술인 AI 에이전트(Antigravity 등)를 연구할 때도, 저는 단순히 겉핥기에 그치지 않고 실제 결과물을 만들어낼 때까지 집요하게 파고듭니다. 이러한 성실함과 탐구심은 제가 AI 시대의 빠른 변화에 누구보다 기민하게 대응할 수 있게 해주는 핵심 동력입니다.',
    hobbies:
        '러닝과 자전거 산책으로 체력을 관리하며, 남는 시간에는 Gemini, Claude 등 최신 LLM을 활용한 디자인 자동화 프롬프트 엔지니어링을 연구합니다. Midjourney를 활용한 고수준 에셋 생성 기법을 익히거나 Antigravity 에이전트의 워크플로우를 분석하는 것이 저의 즐거움입니다. 이는 실무자로서의 감각을 유지하고, 다가올 미래의 디자인 환경을 누구보다 앞서 준비하는 저만의 능동적인 자기계발 방식입니다.',
    aspiration:
        '저는 팀의 가치를 높이는 "최고의 AI 디자인 실무 자산"이 되고 싶습니다. 20년의 내공이 담긴 장인정신과 최신 AI 기술(Gemini, Antigravity 등)에 대한 깊은 연구를 결합하여, 생산성을 극대화하고 품질을 혁신하는 결과물을 보여드리겠습니다. 말이 아닌 실행력으로, 그리고 AI 시대에 딱 맞는 준비된 역량으로 팀의 성과를 직접 증명해 보이겠습니다.',
  );
});
