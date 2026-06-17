import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/models/document_model.dart';

class DocumentsRepository {
  static const String _baseUrl = 'http://localhost:8080';
  final _uuid = const Uuid();

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/data'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return {};
  }

  Future<void> _saveData(Map<String, dynamic> data) async {
    try {
      await http.post(Uri.parse('$_baseUrl/api/data'), body: jsonEncode(data));
    } catch (e) {
      print('Error saving data: $e');
      rethrow;
    }
  }

  /// 모든 문서 목록 가져오기
  Future<List<DocumentModel>> getDocuments() async {
    final data = await _fetchData();
    final list = (data['documents'] as List? ?? [])
        .map((e) => DocumentModel.fromJson(e))
        .toList();
    // Sort desc by updatedAt
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  /// 특정 타입의 문서 목록 가져오기
  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) async {
    final docs = await getDocuments();
    return docs.where((doc) => doc.type == type).toList();
  }

  /// 특정 문서 가져오기
  Future<DocumentModel?> getDocument(String id) async {
    final docs = await getDocuments();
    try {
      return docs.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 새 문서 생성
  Future<DocumentModel> createDocument({
    required DocumentType type,
    required String title,
    required Map<String, dynamic> content,
    String? pdfUrl,
    List<String>? tags,
  }) async {
    final data = await _fetchData();
    final documents = (data['documents'] as List? ?? []).toList();

    final id = _uuid.v4();
    final now = DateTime.now();

    final newDoc = DocumentModel(
      id: id,
      type: type,
      title: title,
      version: '1.0',
      createdAt: now,
      updatedAt: now,
      pdfUrl: pdfUrl,
      content: content,
      tags: tags ?? [],
    );

    documents.add(newDoc.toJson());
    data['documents'] = documents;
    await _saveData(data);

    return newDoc;
  }

  /// 문서 업데이트
  Future<void> updateDocument(DocumentModel document) async {
    final data = await _fetchData();
    final documents = (data['documents'] as List? ?? []).toList();

    final index = documents.indexWhere((e) => e['id'] == document.id);
    if (index != -1) {
      final updatedDoc = DocumentModel(
        id: document.id,
        type: document.type,
        title: document.title,
        version: document.version,
        createdAt: document.createdAt,
        updatedAt: DateTime.now(),
        pdfUrl: document.pdfUrl,
        content: document.content,
        tags: document.tags,
      );

      documents[index] = updatedDoc.toJson();
      data['documents'] = documents;
      await _saveData(data);
    }
  }

  /// 문서 삭제
  Future<void> deleteDocument(String id) async {
    final data = await _fetchData();
    final documents = (data['documents'] as List? ?? []).toList();
    documents.removeWhere((e) => e['id'] == id);
    data['documents'] = documents;
    await _saveData(data);
  }
}
