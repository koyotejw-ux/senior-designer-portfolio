import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Portfolio 데이터 마이그레이션 스크립트
// 하드코딩된 6개 프로젝트를 Firestore에 업로드

void main() async {
  print('Portfolio 데이터 마이그레이션 시작...');

  // Firebase 초기화는 flutter run으로 실행 시 자동으로 됨
  final firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();

  final projects = [
    {
      'id': uuid.v4(),
      'title': 'AIA+ SENIOR MODE',
      'subtitle': '고령자 전용 모드 UX/UI 디자인 시스템',
      'company': 'ING People',
      'year': '2025.02-2025.06',
      'category': 'Mobile App',
      'description': 'AIA 생명 앱 Phase2 고령자 전용 모드 메인 UX 기획 및 디자인 시스템 구축. 보험료 납입, 보험계약대출 상환, 자동부활 신청, 자동송금 신청 등 핵심 GUI 정의. 디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성.',
      'tags': ['Figma', 'Mobile UX', 'Design System', 'Accessibility'],
      'gradientColors': ['#00BCD4', '#2196F3'], // accentCyan, blue400
      'role': 'Product Designer',
      'duration': '2025.02-2025.06 (5개월)',
      'teamSize': '8명 (디자이너 2명, 개발자 4명, PM 2명)',
      'achievements': [
        '고령자 전용 접근성 가이드라인 수립',
        '터치 영역 44px 이상, 폰트 크기 18px 이상 적용',
        '핵심 기능 3단계 이내 도달 UX 설계',
        'Figma 기반 디자인 시스템 구축',
        '디자인 개발 완성률 100%, 일정 준수율 100%'
      ],
      'technologies': ['Figma', 'MS Office', 'Mobile UX', 'Design System'],
      'order': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': uuid.v4(),
      'title': 'LAND DEVELOPMENT',
      'subtitle': '토지개발 분석 솔루션 반응형 웹',
      'company': 'ING People',
      'year': '2025.01-2025.02',
      'category': 'Web Design',
      'description': '토지개발 분석 플랫폼 UX/UI 기획 및 디자인 방향 수립, 디자인 시스템 설계. 반응형 웹 구현으로 PC/태블릿/모바일 대응.',
      'tags': ['Figma', 'Web Design', 'Responsive', 'UX Strategy'],
      'gradientColors': ['#4CAF50', '#00BCD4'], // highlightGreen, accentCyan
      'role': 'Product Designer',
      'duration': '2025.01-2025.02 (2개월)',
      'teamSize': '6명 (디자이너 1명, 개발자 4명, PM 1명)',
      'achievements': [
        'UX/UI 기획 및 디자인 방향 수립',
        '디자인 시스템 설계 완료',
        'PC/태블릿/모바일 반응형 구현',
        '프로젝트 일정 준수율 100%'
      ],
      'technologies': ['Figma', 'Responsive Design', 'UX Planning'],
      'order': 2,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': uuid.v4(),
      'title': 'WALLPAD',
      'subtitle': 'HT 범용 안드로이드 월패드 디자인 시스템',
      'company': 'Hyundai HT',
      'year': '2018.05-2023.12',
      'category': 'IoT Device',
      'description': '동종 업계 1위 유지 기반 HT 안드로이드 월패드 라인업 UX 설계 프로세스 체계화. 현대/포스코/금호/한양/한화/대림 등 고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 통합 디자인 시스템 적용. 디자인 개발 완성률 100%, 프로젝트 일정 준수율 100%.',
      'tags': ['Figma', 'Adobe XD', 'Android', 'Design System', 'Zeplin'],
      'gradientColors': ['#1976D2', '#00BCD4'], // primaryBlue, accentCyan
      'role': 'Product Lead',
      'duration': '5년 7개월 (2018.05-2023.12)',
      'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
      'achievements': [
        '동종 업계 1위 유지 기반 UX 설계 프로세스 체계화',
        '5개 건설사 대응 범용 디자인 시스템 구축',
        '7~24인치 디바이스 대응 반응형 UI 설계',
        '월패드-앱 연동 UX 최적화',
        'HT 범용 월패드 전용 디자인 시스템 구축 및 전 제품군 적용'
      ],
      'technologies': ['Figma', 'Adobe XD', 'Photoshop', 'Illustrator', 'Protopie', 'Zeplin'],
      'order': 3,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': uuid.v4(),
      'title': 'HT HOME 2.0',
      'subtitle': '주거전용 스마트홈 통합 앱',
      'company': 'Hyundai HT',
      'year': '2021.07-2023.04',
      'category': 'Mobile App',
      'description': 'HT HOME 및 HT Imazu 앱 앱스토어 정식 론칭. 월패드와 통합 연동 최적화 및 사용자 접점 확대. 스마트홈 IoT 기기 통합 제어 UX 설계.',
      'tags': ['Figma', 'Adobe XD', 'iOS', 'Android', 'Smart Home', 'Protopie'],
      'gradientColors': ['#42A5F5', '#00BCD4'], // blue400, accentCyan
      'role': 'Product Lead',
      'duration': '1년 9개월 (2021.07-2023.04)',
      'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
      'achievements': [
        'iOS/Android 앱스토어 정식 론칭',
        '월패드-앱 실시간 연동 UX 설계',
        '스마트홈 기기 통합 제어 UI 구축',
        'HT HOME 2.0 및 HT Imazu 앱 UX/UI 전체 설계',
        '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100%'
      ],
      'technologies': ['Figma', 'Adobe XD', 'Protopie', 'Photoshop', 'Illustrator', 'Zeplin'],
      'order': 4,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': uuid.v4(),
      'title': 'SOULARK',
      'subtitle': '모바일 게임 UX/UI 디자인',
      'company': 'BluestoneSoft',
      'year': '2016.05-2017.06',
      'category': 'Game UI',
      'description': 'SOULARK 모바일 게임의 전반적인 UX/UI 개발. Unity3D 기반 GUI 인터랙션 및 애니메이션 설계.',
      'tags': ['Unity3D', 'Mobile', 'Game UI', 'Photoshop'],
      'gradientColors': ['#4CAF50', '#00BCD4'], // highlightGreen, accentCyan
      'role': 'Lead Researcher',
      'duration': '1년 1개월 (2016.05-2017.06)',
      'teamSize': '20명 (디자이너 4명, 개발자 12명, 기획자 4명)',
      'achievements': [
        'Unity3D 기반 GUI 시스템 구축',
        '게임 내 100+ UI 화면 디자인',
        '인터랙션 애니메이션 설계 및 구현',
        '모바일 게임 UX/UI 전체 설계 및 디자인 시스템 구축'
      ],
      'technologies': ['Unity3D', 'Photoshop', 'Illustrator', 'After Effects'],
      'order': 5,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': uuid.v4(),
      'title': 'CLOSERS',
      'subtitle': '클로저스 CBT 반응형 웹사이트',
      'company': 'NEXON Korea',
      'year': '2014.06-2014.09',
      'category': 'Web Design',
      'description': '클로저스 CBT 반응형 웹사이트 UX/UI 개발. NEXON 사내 최초로 PC/태블릿/모바일 대상 반응형 웹 구현 적용.',
      'tags': ['Responsive Web', 'HTML/CSS', 'Game Promotion', 'Photoshop'],
      'gradientColors': ['#1976D2', '#42A5F5'], // primaryBlue, blue400
      'role': 'Manager',
      'duration': '4개월 (2014.06-2014.09)',
      'teamSize': '10명 (디자이너 2명, 개발자 6명, 기획자 2명)',
      'achievements': [
        'NEXON 사내 최초 반응형 웹사이트 구축',
        'PC/태블릿/모바일 3단계 브레이크포인트 설계',
        'CBT 반응형 웹사이트 UX/UI 기획 및 디자인',
        '게임 프로모션 웹사이트 전체 설계'
      ],
      'technologies': ['HTML5', 'CSS3', 'JavaScript', 'Responsive Design', 'Photoshop', 'Illustrator'],
      'order': 6,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];

  int successCount = 0;
  int failCount = 0;

  for (var project in projects) {
    try {
      await firestore
          .collection('portfolios')
          .doc(project['id'] as String)
          .set(project);

      print('✅ 업로드 완료: ${project['title']}');
      successCount++;
    } catch (e) {
      print('❌ 업로드 실패: ${project['title']} - $e');
      failCount++;
    }
  }

  print('\n마이그레이션 완료!');
  print('성공: $successCount개');
  print('실패: $failCount개');
}
