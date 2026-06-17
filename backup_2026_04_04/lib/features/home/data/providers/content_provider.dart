import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.get(Uri.parse('$_baseUrl/api/data'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to load data: ${response.statusCode}');
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
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
