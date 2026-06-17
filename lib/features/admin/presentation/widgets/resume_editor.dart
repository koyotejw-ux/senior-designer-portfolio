import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/resume_model.dart';
import 'resume_print_dialog.dart';

class ResumeEditor extends StatefulWidget {
  const ResumeEditor({super.key});

  @override
  State<ResumeEditor> createState() => _ResumeEditorState();
}

class _ResumeEditorState extends State<ResumeEditor> {
  // 샘플 데이터 (실제로는 provider에서 가져와야 함)
  late ResumeModel _resume;
  late CoverLetterModel _coverLetter;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _resume = ResumeModel(
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
          major: '시각디자인학과 (학사)',
          gpa: '4.25 / 4.5',
        ),
        Education(
          period: '1999.03 ~ 2004.02',
          institution: '청강문화산업대학교',
          major: '애니메이션과 (3D)',
          gpa: '3.34 / 4.2',
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
          tools: const ['Flutter', 'Unity3D', 'Figma', 'ChatGPT', 'Gemini', 'Claude'],
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
          company: '아이엔지피플 (INGPPL)',
          department: 'UX팀',
          position: '매니저',
          role: 'Product Designer / UX UI 기획 및 디자인 디렉션',
          projects: [
            'AIA생명 앱 : 고령자 모드 UX/UI 고도화 개발 (Product Designer)',
            '한국 마사회 비즈온 앱 UX/UI 시안 개발 (Product Designer)',
            'AI 기반 토지개발 분석 솔루션 반응형 웹 UX/UI 개발 (Product Designer)',
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
          role: 'Product Lead / 스마트홈 시스템 UX 총괄 디자인',
          projects: [
            'HT 범용 24인치 안드로이드 월패드 UX/UI 개발 총괄',
            '포스코건설/현대건설/현대엔지니어링 전용 안드로이드 월패드(7~13.3인치) UX/UI 개발',
            'HT HOME 2.0 및 IoT 앱 UX/UI 고도화 리딩',
            'PSQC (포스코 더샵 퀄리티 컨트롤) 시운전 솔루션 웹사이트 UX/UI 개발',
            '대림산업/금호건설/한양건설/한화건설 전용 월패드 UX/UI 커스터마이징 리딩',
          ],
          achievements: [
            '국내 스마트홈 업계 1위 유지의 기반이 되는 HT 월패드 라인업 UX 설계 프로세스 체격화',
            '고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 디자인 시스템 일괄 적용',
            'HT HOME 및 HT Imazu 앱 앱스토어 론칭 및 사용자 접점 확대',
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
          role: 'UX/UI Designer / 모바일 게임 인터페이스 설계',
          projects: ['SOULARK 모바일 게임 UX/UI 개발'],
          achievements: [
            '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성',
            '개발 프로세스 효율성 20% 향상',
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
          role: 'UX/UI Designer / PC 및 모바일 게임 UX 시각화',
          projects: [
            'Project B/V/OX 모바일 게임 UX/UI 개발',
            '클로저스 CBT 반응형 웹사이트 및 공식 웹사이트 UX/UI 리딩',
            '넥슨 아레나 경기장 전용 앱 UX/UI 개발',
            '카트라이더 / 크레이지아케이드 / 엘소드 등 라이브 게임 UX/UI 디자인 운영',
            '영웅시대30 MMORPG 인게임 GUI 리뉴얼 및 웹사이트 개발',
          ],
          achievements: [
            '사내 최초 클로저스 CBT 웹사이트에 PC/태블릿/모바일 반응형 웹 구현 적용',
            '다양한 게임 프로모션 디자인을 통해 유저 유입률 및 매출 상승 기여',
            '영웅시대30 인게임 GUI 리뉴얼 및 성공적 론칭 주도',
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
          role: 'UX/UI Designer / 게임 브랜드 웹 플랫폼 구축',
          projects: [
            '로한 시공의탑 웹게임(Flash AS2.0) UX/UI 개발',
            '스팅 마이크로/OBT 신규 웹사이트(Full Flash) UX/UI 개발',
            '로한/배틀로한/씰온라인 웹사이트 UX/UI 디자인 운영',
          ],
          achievements: [
            'Flash AS2.0 기반 고수준 UX/UI 디자인으로 웹게임 구현 및 신규 조직 신설 기여',
            '다양한 프로모션을 통한 유저 유입률 및 매출 증가 기여',
          ],
          tools: ['Photoshop', 'Illustrator', 'Flash (AS 2.0)'],
          environment: 'Web',
          resignationReason: '경영악화 (구조조정)',
        ),
        Career(
          period: '2008.03 ~ 2008.07',
          company: '비엠소프트',
          department: 'E스포츠사업부',
          position: '대리',
          role: 'UX/UI Designer / 게임 리그 플랫폼 디자인',
          projects: ['WAPL 아마추어 게임 리그 웹사이트 UX/UI 기획 및 개발', 'WAPL 비즈니스 디자인 운영'],
          achievements: ['WAPL 아마추어 게임 리그 웹사이트 기획 및 성공적 론칭'],
          tools: [
            'Photoshop',
            'Illustrator',
            '3DMAX',
            'After Effects',
            'Flash',
          ],
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
          achievements: [
            '인테리어 3D 공간 디자인 제작을 통한 실계약 성사 기여',
            '웹사이트 수주를 통한 매출 기여',
          ],
          tools: ['Photoshop', 'Illustrator', '3DMAX', 'Flash', 'PHP'],
          environment: 'Web',
          resignationReason: '경영악화 (폐업)',
        ),
      ],
      coreCompetencies: const [
        '17년의 실무 경력을 바탕으로 한 비즈니스 전략 기반의 엔드-투-엔드(E2E) UX/UI 아키텍처 수립',
        '전자/제조(스마트홈), 금융(AIA생명), 게임(넥슨), 웹 서비스 등 다양한 도메인을 아우르는 크로스 인더스트리 인사이트',
        '7인치부터 24인치까지 아우르는 크로스 디바이스(Cross-device) 레이아웃 및 디자인 시스템 표준화 역량',
        '디자인 리더십 및 거버넌스 구축 (조직 관리, 디자인 프로세스 디지털 트랜스포메이션 주도)',
        'Figma, Protopie, Unity3D, 3ds Max 등 최신 도구와 기술을 활용한 고수준의 UX 프로토타이핑 및 검증',
      ],
      certifications: const [
        Certification(name: '시각디자인산업기사', issuer: '한국산업인력공단', date: '2006.05'),
        Certification(name: '유통관리사 2급', issuer: '대한상공회의소', date: '2006.11'),
        Certification(name: '워드프로세서 1급', issuer: '대한상공회의소', date: '2006.02'),
      ],
    );

    _coverLetter = const CoverLetterModel(
      id: 'coverletter_1',
      greeting:
          '기획부터 디자인, 협업까지 사용자 중심의 해결을 먼저 생각하는 디자이너, 정재웅입니다. 정보를 단순하게, 시각은 명확하게 전달하는 것을 중요하게 생각하며, 사용자 입장에서 먼저 고민하고 설명 가능한 디자인을 지향합니다. 에이전시부터 제조, 통신업까지 다양한 산업군에서 UX/UI 디자인을 수행해왔으며, Web, Android, iOS, Linux 등 여러 플랫폼 환경에 맞춰 설계와 구현을 진행해왔습니다. 각 플랫폼의 사용자 흐름과 사용성을 고려하여 UX 기획부터 UI 설계, 프로토타이핑, 디자인 시스템 구축까지 전반적인 과정을 수행해왔습니다. 특히 최근에는 개발자와의 원활한 협업을 위해 UI를 직접 구현해보며 Flutter를 활용해 개발적인 이해를 넓히고자 하는 시도도 병행하고 있습니다. 또한, AI 시대에 맞춰 ChatGPT, Stable Diffusion 등의 도구를 디자인 업무에 어떻게 접목할 수 있을지 다양한 방식으로 실험해보고 있으며, 현재는 ChatGPT AI Studio(vio3)를 중심으로 적극 활용하고 있습니다.',
      background:
          '어릴 때부터 그림, 애니메이션, 게임에 자연스럽게 흥미를 느껴왔고, 중·고등학교 시절에는 틈틈이 그림을 그리고 애니메이션을 감상하며 시각적 요소와 그래픽의 구성, 연출 방식에 관심을 갖게 되었습니다. 이러한 관심은 진로로도 이어져 애니메이션과에 진학하게 되었고, 다양한 시각적 표현과 디자인에 대한 이해를 넓힐 수 있는 계기가 되었습니다. 군 복무를 마친 뒤에는 공간적인 연출과 구성의 매력에 이끌려 3D 애니메이션을 세부 전공으로 선택했고, 졸업 작품을 통해 장면마다 담긴 디테일과 표현의 중요성을 깊이 체감할 수 있었습니다. 이후 실무에 발을 들이며 긴 제작 주기를 거치는 3D 작업보다 빠른 피드백과 다양한 인터랙션이 가능한 웹 기반 디자인에 더 큰 매력을 느꼈고, 이를 계기로 UX/UI 디자인에 본격적으로 뛰어들게 되었습니다.',
      personality:
          '저는 사람들과 자연스럽게 소통하고, 진솔하게 관계를 맺는 데 강점이 있는 편입니다. 새로운 사람에게도 서스럼 없이 다가가며, 상대방을 진심으로 이해하고 존중하려는 태도로 협업에 임합니다. 함께 일하는 동료들에게는 신뢰와 배려를 바탕으로 건강한 협업 문화를 만드는 것을 중요하게 생각합니다. 맡은 일에 대한 책임감도 강한 편입니다. 프로젝트 일정이 촉박하거나 예기치 못한 변수들이 생기더라도, 주어진 역할에 최선을 다해 프로젝트를 끝까지 완수해왔습니다. 지금까지 참여한 프로젝트에서 단 한 번도 중도 이탈하거나 실패한 경험 없이, 항상 책임 있는 자세로 결과를 만들어냈습니다. 또한 저는 변화에 유연하게 대응하며, 새로운 도전에 적극적으로 임합니다. 스스로 학습하고 실험하면서 꾸준히 성장해왔습니다.',
      hobbies:
          '운동을 잘하진 않지만 꾸준히 좋아하는 편이라, 시간이 날 때마다 가볍게 러닝이나 풀업을 하며 컨디션을 관리하고 있습니다. 자전거 산책과 여행도 즐겨 하는데, 자전거를 타고 이동하다 보면 가까이 있지만 놓치기 쉬운 소소하고 멋진 장면들을 마주하게 되는 것이 큰 매력입니다. 이러한 경험들은 일상 속 작은 디테일을 놓치지 않는 관찰력으로 이어져 디자인 작업에도 긍정적인 영향을 주곤 합니다. 가끔은 산을 오르며 마음을 정리하기도 하고, 전공서적도 틈틈이 읽으며 디자인 관점을 확장하려 노력하고 있습니다.',
      aspiration:
          '목표를 향해 가는 길이 때로는 멀고 험할 수 있지만, 저는 그 과정 또한 새로운 기회이자 성장의 시간이라고 생각합니다. 단지 결과만을 좇기보다, 과정 속에서 끊임없이 배우고 발전하며 완성도 있는 결과에 도달하는 것을 중요하게 여깁니다. 채용공고를 보았을 때, 저의 경험과 가치 관계 이곳의 방향성과 잘 맞닿아 있다고 느꼈고, 함께 성장해보고 싶다는 확신이 들었습니다. 기회를 주신다면, 지금까지 쌓아온 경험과 역량을 바탕으로 팀과 함께 의미 있는 결과를 만들어가기 위해 최선을 다하겠습니다.',
    );
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ResumePrintDialog(resume: _resume, coverLetter: _coverLetter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이력서 섹션
            Card(
              color: AppColors.charcoal,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이력서',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoTile('성명', _resume.personalInfo.name),
                    _buildInfoTile('생년월일', _resume.personalInfo.birthDate),
                    _buildInfoTile('연락처', _resume.personalInfo.phone),
                    _buildInfoTile('이메일', _resume.personalInfo.email),
                    const SizedBox(height: 15),
                    Text(
                      '학력: ${_resume.education.length}건',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '경력: ${_resume.careers.length}건',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '핵심역량: ${_resume.coreCompetencies.length}건',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '자격증: ${_resume.certifications.length}건',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 자기소개서 섹션
            Card(
              color: AppColors.charcoal,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '자기소개서',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoTile(
                      '인사말',
                      '${_coverLetter.greeting.substring(0, 50)}...',
                    ),
                    _buildInfoTile(
                      '성장배경',
                      '${_coverLetter.background.substring(0, 50)}...',
                    ),
                    _buildInfoTile(
                      '성격',
                      '${_coverLetter.personality.substring(0, 50)}...',
                    ),
                    _buildInfoTile(
                      '취미',
                      '${_coverLetter.hobbies.substring(0, 50)}...',
                    ),
                    _buildInfoTile(
                      '입사 후 포부',
                      '${_coverLetter.aspiration.substring(0, 50)}...',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPrintDialog,
        backgroundColor: AppColors.highlightGreen,
        icon: const Icon(Icons.print, color: Colors.black),
        label: const Text(
          'Export PDF',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
