import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/atomic_design_model.dart';

const String _baseUrl = 'http://localhost:8080';

class AtomicDesignRepository {
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
      final response = await http.post(
        Uri.parse('$_baseUrl/api/data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving data: $e');
      rethrow;
    }
  }

  Future<AtomicDesignModel> getAtomicDesign() async {
    final data = await _fetchData();
    final atomicData = data['atomic_design'];
    if (atomicData == null) return const AtomicDesignModel();
    return AtomicDesignModel.fromJson(atomicData);
  }

  Future<void> saveComponent(AtomicComponent component) async {
    final data = await _fetchData();
    final atomicData = Map<String, dynamic>.from(data['atomic_design'] ?? {});

    final levelKey = _getLevelKey(component.level);
    final components = List<Map<String, dynamic>>.from(
      atomicData[levelKey] ?? [],
    );

    final index = components.indexWhere((e) => e['id'] == component.id);
    if (index != -1) {
      components[index] = component.toJson();
    } else {
      components.add(component.toJson());
    }

    atomicData[levelKey] = components;
    data['atomic_design'] = atomicData;
    await _saveData(data);
  }

  Future<void> deleteComponent(String id, AtomicLevel level) async {
    final data = await _fetchData();
    final atomicData = Map<String, dynamic>.from(data['atomic_design'] ?? {});

    final levelKey = _getLevelKey(level);
    final components = List<Map<String, dynamic>>.from(
      atomicData[levelKey] ?? [],
    );

    components.removeWhere((e) => e['id'] == id);

    atomicData[levelKey] = components;
    data['atomic_design'] = atomicData;
    await _saveData(data);
  }

  String _getLevelKey(AtomicLevel level) {
    switch (level) {
      case AtomicLevel.foundation:
        return 'foundations';
      case AtomicLevel.atom:
        return 'atoms';
      case AtomicLevel.molecule:
        return 'molecules';
      case AtomicLevel.organism:
        return 'organisms';
      case AtomicLevel.template:
        return 'templates';
      case AtomicLevel.page:
        return 'pages';
    }
  }
}

final atomicDesignRepositoryProvider = Provider<AtomicDesignRepository>((ref) {
  return AtomicDesignRepository();
});

final atomicDesignProvider = FutureProvider<AtomicDesignModel>((ref) {
  return ref.watch(atomicDesignRepositoryProvider).getAtomicDesign();
});
