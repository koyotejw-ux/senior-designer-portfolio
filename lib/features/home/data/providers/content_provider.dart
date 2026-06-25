import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' as flutter;
import '../models/project_model.dart';
import '../models/profile_model.dart';
import '../models/experience_model.dart';
import '../models/education_model.dart';
import '../models/skill_model.dart';

import 'package:uuid/uuid.dart';

const String _baseUrl = 'http://localhost:8080';

// Repository
class ContentRepository {
  final _uuid = const Uuid();

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/data')).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (e) {
      print('Error fetching data from server, falling back to local fallback data: $e');
      return _getDefaultFallbackData();
    }
  }

  static Future<String> flutter_services_fallback() async {
    try {
      return await flutter.rootBundle.loadString('assets/data/db.json');
    } catch (_) {
      try {
        return await flutter.rootBundle.loadString('server/data/db.json');
      } catch (_) {
        return '{}';
      }
    }
  }

  Map<String, dynamic> _getDefaultFallbackData() {
    return {
      "projects": [
        {
          "id": "p8",
          "title": "SAM MES+ERP SYSTEM",
          "subtitle": "제조 생산 관리 시스템(MES) 및 ERP UX/UI",
          "company": "(주)코드브릿지엑스",
          "year": "2025.09 - 2026.01",
          "category": "Web Design",
          "description": "삼성 제조 MES 대시보드 화면 설계 및 가시성 개선. ERP 시스템 데이터 그리드 및 상세 제어 레이아웃 표준화.",
          "tags": ["플랫폼: WEB 반응형", "Figma", "Enterprise", "Dashboard"],
          "imageUrl": "assets/images/sam_mes_thumbnail.jpg",
          "gradientColors": ["#0056B3", "#00A8FF"],
          "role": "Lead Product Designer",
          "duration": "5개월 (2025.09-2026.01)",
          "teamSize": "10명 (디자이너 2명, 개발자 6명, PM 2명)",
          "mainScreenImages": ["assets/images/sam_mes_final.jpg"],
          "isCorporate": false,
          "order": 0
        },
        {
          "id": "p7",
          "title": "토지개발플랫폼",
          "subtitle": "토지개발분석 솔루션",
          "company": "Smart Farm Solution",
          "year": "2023.10 - 2024.03",
          "category": "Web Design",
          "description": "토지 개발 분석 및 부동산 개발 프로젝트 협업 솔루션 UX/UI 기획 및 디자인.",
          "tags": ["플랫폼: WEB 반응형", "Dashboard", "Design System", "Figma"],
          "imageUrl": "assets/images/farm_1.jpg",
          "gradientColors": ["#4CAF50", "#8BC34A"],
          "role": "Lead Product Designer",
          "duration": "6개월 (2023.10-2024.03)",
          "teamSize": "6명 (디자이너 1명, 개발자 4명, PM 1명)",
          "mainScreenImages": ["assets/images/farm_1.jpg", "assets/images/farm_2.jpg", "assets/images/farm_3.jpg"],
          "isCorporate": false,
          "order": 1
        },
        {
          "id": "p1",
          "title": "AIA+ SENIOR MODE",
          "subtitle": "고령자 전용 모드 UX/UI 디자인 시스템",
          "company": "아이엔지피플",
          "year": "2025.01 - 2025.06",
          "category": "Mobile App",
          "description": "AIA 생명 앱 Phase2 고령자 전용 모드 메인 UX 기획 및 디자인 시스템 구축. 보험료 납입, 보험계약대출 상환, 자동부활 신청, 자동송금 신청 등 핵심 GUI 정의. 디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성.",
          "tags": ["플랫폼: AOS/iOS APP & WEB", "Figma", "Design System", "Accessibility"],
          "imageUrl": "assets/images/aia_thumbnail.jpg",
          "gradientColors": ["#D31145", "#FF4B4B"],
          "role": "Senior Product Designer",
          "duration": "6개월 (2025.01-2025.06)",
          "teamSize": "8명 (디자이너 2명, 개발자 4명, PM 2명)",
          "mainScreenImages": ["assets/images/aia.jpg"],
          "isCorporate": false,
          "order": 2
        },
        {
          "id": "p2",
          "title": "현대에이치티 월패드",
          "subtitle": "HT 범용 안드로이드 월패드 디자인 시스템",
          "company": "현대에이치티(주)",
          "year": "2018.05 - 2024.03",
          "category": "IoT Device",
          "description": "동종 업계 1위 유지 기반 HT 안드로이드 월패드 라인업 UX 설계 프로세스 체계화. 현대/포스코/금호/한양/한화/대림 등 고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 통합 디자인 시스템 적용. 디자인 개발 완성률 100%, 프로젝트 일정 준수율 100%.",
          "tags": ["플랫폼: 안드로이드 CUSTOM OS", "Figma", "Design System", "IoT UI/UX"],
          "imageUrl": "assets/images/ht_thumbnail.jpg",
          "gradientColors": ["#1976D2", "#00BCD4"],
          "role": "Product Lead",
          "duration": "5년 10개월 (2018.05-2024.03)",
          "teamSize": "15명 (디자이너 3명, 개발자 10명, PM 2명)",
          "mainScreenImages": ["assets/images/ht_01_slice_1.jpg", "assets/images/ht_01_slice_2.jpg", "assets/images/ht_01_slice_3.jpg", "assets/images/ht_01_slice_4.jpg", "assets/images/ht_01_slice_5.jpg", "assets/images/ht_01_slice_6.jpg", "assets/images/ht_02_1_slice_1.jpg", "assets/images/ht_02_1_slice_2.jpg", "assets/images/ht_02_1_slice_3.jpg", "assets/images/ht_02_1_slice_4.jpg", "assets/images/ht_02_2_slice_1.jpg", "assets/images/ht_02_2_slice_2.jpg", "assets/images/ht_02_2_slice_3.jpg", "assets/images/ht_02_2_slice_4.jpg", "assets/images/ht_03_1_slice_1.jpg", "assets/images/ht_03_1_slice_2.jpg", "assets/images/ht_03_1_slice_3.jpg", "assets/images/ht_03_1_slice_4.jpg", "assets/images/ht_03_2_slice_1.jpg", "assets/images/ht_03_2_slice_2.jpg", "assets/images/ht_03_2_slice_3.jpg", "assets/images/ht_03_2_slice_4.jpg"],
          "isCorporate": false,
          "order": 3
        },
        {
          "id": "p3",
          "title": "HT HOME 2.0",
          "subtitle": "주거전용 스마트홈 통합 앱",
          "company": "현대에이치티(주)",
          "year": "2021.07 - 2023.04",
          "category": "Mobile App",
          "description": "HT HOME 및 HT Imazu 앱 앱스토어 정식 론칭. 월패드와 통합 연동 최적화 및 사용자 접점 확대. 스마트홈 IoT 기기 통합 제어 UX 설계.",
          "tags": ["플랫폼: AOS/iOS APP", "Smart Home", "iOS & Android"],
          "imageUrl": "assets/images/hthome_thumbnail.jpg",
          "gradientColors": ["#42A5F5", "#00BCD4"],
          "role": "Senior Product Designer",
          "duration": "2년 (2021-2023)",
          "teamSize": "15명 (디자이너 3명, 개발자 10명, PM 2명)",
          "mainScreenImages": ["assets/images/hthome_01_1_slice_1.jpg", "assets/images/hthome_01_1_slice_2.jpg", "assets/images/hthome_01_1_slice_3.jpg", "assets/images/hthome_01_1_slice_4.jpg", "assets/images/hthome_01_2_slice_1.jpg", "assets/images/hthome_01_2_slice_2.jpg", "assets/images/hthome_01_2_slice_3.jpg", "assets/images/hthome_01_2_slice_4.jpg", "assets/images/hthome_01_3_slice_1.jpg", "assets/images/hthome_01_3_slice_2.jpg", "assets/images/hthome_01_3_slice_3.jpg", "assets/images/hthome_01_3_slice_4.jpg"],
          "isCorporate": false,
          "order": 4
        },
        {
          "id": "p4",
          "title": "SOULARK",
          "subtitle": "모바일 게임 UX/UI 디자인",
          "company": "(주)블루스톤소프트",
          "year": "2016.05 - 2017.06",
          "category": "Game UI",
          "description": "SOULARK 모바일 게임의 전반적인 UX/UI 개발. Unity3D 기반 GUI 인터랙션 및 애니메이션 설계.",
          "tags": ["플랫폼: AOS/iOS (UNITY3D)", "Game UI", "Photoshop"],
          "imageUrl": "assets/images/soulark_1.jpg",
          "gradientColors": ["#8A2BE2", "#4169E1"],
          "role": "UI/UX Designer",
          "duration": "1년 1개물 (2016.05-2017.06)",
          "teamSize": "20명 (디자이너 4명, 개발자 12명, 기획자 4명)",
          "mainScreenImages": ["assets/images/soulark_1.jpg", "assets/images/soulark_2.jpg", "assets/images/soulark_3.jpg"],
          "isCorporate": false,
          "order": 5
        },
        {
          "id": "p5",
          "title": "CLOSERS",
          "subtitle": "클로저스 웹사이트 UX/UI 디자인",
          "company": "(주)넥슨코리아",
          "year": "2014.06 - 2014.12",
          "category": "Web Design",
          "description": "클로저스 CBT 반응형 웹사이트 UX/UI 개발. 사내 최초로 PC/태블릿/모바일 대상 반응형 웹 구현 적용.",
          "tags": ["플랫폼: 반응형 웹", "Game Promotion", "HTML/CSS"],
          "imageUrl": "assets/images/closers_1.jpg",
          "gradientColors": ["#2196F3", "#1E88E5"],
          "role": "Web Designer",
          "duration": "6개월 (2014)",
          "teamSize": "10명 (디자이너 2명, 개발자 6명, 기획자 2명)",
          "mainScreenImages": ["assets/images/closers_1.jpg", "assets/images/closers_2.jpg", "assets/images/closers_3.jpg"],
          "isCorporate": false,
          "order": 6
        },
        {
          "id": "p6",
          "title": "NEXON PROMOTION",
          "subtitle": "넥슨 게임 프로모션 디자인 및 웹 퍼블리싱",
          "company": "(주)넥슨코리아",
          "year": "2010.10 - 2015.12",
          "category": "Web Design",
          "description": "넥슨 라이브 게임들의 대규모 업데이트 및 신작 론칭 프로모션 웹사이트 UX/UI 디자인 및 퍼블리싱 총괄. 사내 표준 마크업 가이드 준수 및 크로스 브라우징 완벽 구현.",
          "tags": ["플랫폼: 웹", "Promotion", "HTML/CSS", "Photoshop"],
          "imageUrl": "assets/images/promotion_1.jpg",
          "gradientColors": ["#FF9800", "#FF5722"],
          "role": "Senior Web Designer",
          "duration": "5년 2개월 (2010-2015)",
          "teamSize": "8명 (디자이너 2명, 개발자 4명, PM 2명)",
          "mainScreenImages": ["assets/images/promotion_1.jpg", "assets/images/promotion_2.jpg"],
          "isCorporate": false,
          "order": 7
        }
      ],
      "profile": {
        "id": "profile",
        "name": "정재웅 (Jaewoong Jung)",
        "birth": "1979.08.14",
        "address": "고양시 덕양구 향기5로 66",
        "military": "육군 병장 전역 (1999.11 - 2002.01)",
        "phone": "010-4375-3599",
        "email": "coyotejw@naver.com",
        "introduction": "에이전시부터 게임 엔터테인먼트, 제조 디바이스까지 다양한 사업군에서 17년 이상의 UX/UI 수행 경험을 보유한 시니어 프로덕트 디자이너입니다. UX/UI 기획과 디자인 모두 수행 가능하며, Hi-Fi Prototyping 2D/3D 작업이 가능합니다.",
        "philosophy": "사용자 중심의 디자인 철학을 바탕으로, 복잡한 시스템을 직관적이고 효율적인 인터페이스로 구현합니다. 디자인 시스템 구축과 일관된 사용자 경험 제공을 통해 비즈니스 가치를 창출합니다.",
        "aspirations": "디자인 그룹 관리 경험(UX/UI 디렉팅/인력관리/외주관리/일정관리/신규업무 생성)을 바탕으로, 효율적인 디자인 프로세스를 체계화하고 조직의 디자인 역량을 강화하는 리더가 되고자 합니다."
      },
      "experience": [
        {
          "id": "e0",
          "company": "(주)코드브릿지엑스",
          "role": "팀원",
          "period": "2025.10 - 2026.01",
          "description": "제조 MES 및 ERP 시스템 UX/UI 설계 및 디자인·개발 협업 프로세스 혁신",
          "tags": ["Enterprise System", "AI Workflow"],
          "order": 0
        },
        {
          "id": "e1",
          "company": "ING People",
          "role": "팀원",
          "period": "2025.01 - 2025.06",
          "description": "AIA 생명 앱 고령자 모드 및 토지개발 분석 솔루션 UX/UI 리딩",
          "tags": ["Fintech", "UX Strategy"],
          "order": 1
        },
        {
          "id": "e2",
          "company": "Hyundai HT",
          "role": "팀장 (수석연구원)",
          "period": "2018.05 - 2024.03",
          "description": "스마트홈 월패드 및 모바일 앱 서비스 통합 UX/UI 디자인 총괄",
          "tags": ["Smart Home", "IoT", "Lead"],
          "order": 2
        }
      ]
    };
  }


  Future<void> _saveData(Map<String, dynamic> data) async {
    try {
      print('Saving data to server: ${jsonEncode(data).substring(0, 200)}...');
      final response = await http.post(
        Uri.parse('$_baseUrl/api/data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print('Save response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to save data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving data: $e');
      rethrow; // Propagate error for UI handling
    }
  }

  // Projects
  Future<List<ProjectModel>> getProjects() async {
    final data = await _fetchData();
    final projects = (data['projects'] as List? ?? [])
        .map((e) => ProjectModel.fromMap(e, e['id'] ?? _uuid.v4()))
        .toList();
    projects.sort((a, b) => a.order.compareTo(b.order));
    return projects;
  }

  Future<void> addProject(ProjectModel project) async {
    final data = await _fetchData();
    final projects = (data['projects'] as List? ?? []).toList();
    final projectMap = project.toMap();
    print('Adding project: ${projectMap['title']} with image: ${projectMap['imageUrl']}');
    projects.add(projectMap);
    data['projects'] = projects;
    await _saveData(data);
    print('Project added successfully');
  }

  Future<void> updateProject(ProjectModel project) async {
    final data = await _fetchData();
    final projects = (data['projects'] as List? ?? []).toList();
    final index = projects.indexWhere((e) => e['id'] == project.id);
    if (index != -1) {
      final projectMap = project.toMap();
      print('Updating project at index $index: ${projectMap['title']} with image: ${projectMap['imageUrl']}');
      projects[index] = projectMap;
      data['projects'] = projects;
      await _saveData(data);
      print('Project updated successfully');
    } else {
      print('Project not found for update: ${project.id}');
    }
  }

  Future<void> deleteProject(String projectId) async {
    final data = await _fetchData();
    final projects = (data['projects'] as List? ?? []).toList();
    projects.removeWhere((e) => e['id'] == projectId);
    data['projects'] = projects;
    await _saveData(data);
  }

  Future<void> reorderProjects(List<ProjectModel> projects) async {
    final data = await _fetchData();
    data['projects'] = projects.map((p) => p.toMap()).toList();
    await _saveData(data);
  }

  // Profile
  Future<ProfileModel?> getProfile() async {
    final data = await _fetchData();
    final profileData = data['profile'];
    if (profileData == null) return null;
    return ProfileModel.fromMap(profileData, 'profile');
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final data = await _fetchData();
    data['profile'] = profile.toMap();
    await _saveData(data);
  }

  // Experience
  Future<List<ExperienceModel>> getExperiences() async {
    final data = await _fetchData();
    final list = (data['experience'] as List? ?? [])
        .map((e) => ExperienceModel.fromMap(e, e['id'] ?? _uuid.v4()))
        .toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  Future<void> addExperience(ExperienceModel experience) async {
    final data = await _fetchData();
    final list = (data['experience'] as List? ?? []).toList();
    list.add(experience.toMap());
    data['experience'] = list;
    await _saveData(data);
  }

  Future<void> updateExperience(ExperienceModel experience) async {
    final data = await _fetchData();
    final list = (data['experience'] as List? ?? []).toList();
    final index = list.indexWhere((e) => e['id'] == experience.id);
    if (index != -1) {
      list[index] = experience.toMap();
      data['experience'] = list;
      await _saveData(data);
    }
  }

  Future<void> deleteExperience(String id) async {
    final data = await _fetchData();
    final list = (data['experience'] as List? ?? []).toList();
    list.removeWhere((e) => e['id'] == id);
    data['experience'] = list;
    await _saveData(data);
  }

  Future<void> reorderExperiences(List<ExperienceModel> experiences) async {
    final data = await _fetchData();
    data['experience'] = experiences.map((e) => e.toMap()).toList();
    await _saveData(data);
  }

  // Education
  Future<List<EducationModel>> getEducations() async {
    final data = await _fetchData();
    final list = (data['education'] as List? ?? [])
        .map((e) => EducationModel.fromMap(e, e['id'] ?? _uuid.v4()))
        .toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  Future<void> addEducation(EducationModel education) async {
    final data = await _fetchData();
    final list = (data['education'] as List? ?? []).toList();
    list.add(education.toMap());
    data['education'] = list;
    await _saveData(data);
  }

  Future<void> updateEducation(EducationModel education) async {
    final data = await _fetchData();
    final list = (data['education'] as List? ?? []).toList();
    final index = list.indexWhere((e) => e['id'] == education.id);
    if (index != -1) {
      list[index] = education.toMap();
      data['education'] = list;
      await _saveData(data);
    }
  }

  Future<void> deleteEducation(String id) async {
    final data = await _fetchData();
    final list = (data['education'] as List? ?? []).toList();
    list.removeWhere((e) => e['id'] == id);
    data['education'] = list;
    await _saveData(data);
  }

  Future<void> reorderEducations(List<EducationModel> educations) async {
    final data = await _fetchData();
    data['education'] = educations.map((e) => e.toMap()).toList();
    await _saveData(data);
  }

  // Skills
  Future<List<SkillModel>> getSkills() async {
    final data = await _fetchData();
    final list = (data['skills'] as List? ?? [])
        .map((e) => SkillModel.fromMap(e, e['id'] ?? _uuid.v4()))
        .toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  Future<void> addSkill(SkillModel skill) async {
    final data = await _fetchData();
    final list = (data['skills'] as List? ?? []).toList();
    list.add(skill.toMap());
    data['skills'] = list;
    await _saveData(data);
  }

  Future<void> updateSkill(SkillModel skill) async {
    final data = await _fetchData();
    final list = (data['skills'] as List? ?? []).toList();
    final index = list.indexWhere((e) => e['id'] == skill.id);
    if (index != -1) {
      list[index] = skill.toMap();
      data['skills'] = list;
      await _saveData(data);
    }
  }

  Future<void> deleteSkill(String id) async {
    final data = await _fetchData();
    final list = (data['skills'] as List? ?? []).toList();
    list.removeWhere((e) => e['id'] == id);
    data['skills'] = list;
    await _saveData(data);
  }

  Future<void> reorderSkills(List<SkillModel> skills) async {
    final data = await _fetchData();
    data['skills'] = skills.map((s) => s.toMap()).toList();
    await _saveData(data);
  }
}

// Providers
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) {
  return ref.watch(contentRepositoryProvider).getProjects();
});

final profileProvider = FutureProvider<ProfileModel?>((ref) {
  return ref.watch(contentRepositoryProvider).getProfile();
});

final experienceProvider = FutureProvider<List<ExperienceModel>>((ref) {
  return ref.watch(contentRepositoryProvider).getExperiences();
});

final educationProvider = FutureProvider<List<EducationModel>>((ref) {
  return ref.watch(contentRepositoryProvider).getEducations();
});

final skillsProvider = FutureProvider<List<SkillModel>>((ref) {
  return ref.watch(contentRepositoryProvider).getSkills();
});
