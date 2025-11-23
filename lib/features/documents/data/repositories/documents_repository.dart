import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/document_model.dart';

class DocumentsRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'documents';
  final _uuid = const Uuid();

  DocumentsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 모든 문서 목록 가져오기
  Future<List<DocumentModel>> getDocuments() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DocumentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('문서 목록 불러오기 실패: $e');
    }
  }

  /// 특정 타입의 문서 목록 가져오기
  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('type', isEqualTo: type.name)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DocumentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('문서 목록 불러오기 실패: $e');
    }
  }

  /// 특정 문서 가져오기
  Future<DocumentModel?> getDocument(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        return DocumentModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('문서 불러오기 실패: $e');
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
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      final document = DocumentModel(
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

      await _firestore
          .collection(_collection)
          .doc(id)
          .set(document.toJson());

      return document;
    } catch (e) {
      throw Exception('문서 생성 실패: $e');
    }
  }

  /// 문서 업데이트
  Future<void> updateDocument(DocumentModel document) async {
    try {
      final updatedDocument = DocumentModel(
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

      await _firestore
          .collection(_collection)
          .doc(document.id)
          .update(updatedDocument.toJson());
    } catch (e) {
      throw Exception('문서 업데이트 실패: $e');
    }
  }

  /// 문서 삭제
  Future<void> deleteDocument(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('문서 삭제 실패: $e');
    }
  }

  /// 문서 실시간 구독
  Stream<List<DocumentModel>> watchDocuments() {
    return _firestore
        .collection(_collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromJson(doc.data()))
            .toList());
  }

  /// 특정 타입 문서 실시간 구독
  Stream<List<DocumentModel>> watchDocumentsByType(DocumentType type) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type.name)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentModel.fromJson(doc.data()))
            .toList());
  }
}
