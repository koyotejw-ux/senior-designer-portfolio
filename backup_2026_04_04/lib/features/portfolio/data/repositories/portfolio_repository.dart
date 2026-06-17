import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/portfolio_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'portfolios';
  final _uuid = const Uuid();

  PortfolioRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<PortfolioModel>> getPortfolios() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => PortfolioModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('포트폴리오 목록 불러오기 실패: $e');
    }
  }

  Future<List<PortfolioModel>> getPortfoliosByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => PortfolioModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('포트폴리오 목록 불러오기 실패: $e');
    }
  }

  Future<PortfolioModel?> getPortfolio(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        return PortfolioModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('포트폴리오 불러오기 실패: $e');
    }
  }

  Future<PortfolioModel> createPortfolio(PortfolioModel portfolio) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      final newPortfolio = portfolio.copyWith(
        id: id,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collection)
          .doc(id)
          .set(newPortfolio.toJson());

      return newPortfolio;
    } catch (e) {
      throw Exception('포트폴리오 생성 실패: $e');
    }
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    try {
      final updatedPortfolio = portfolio.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(portfolio.id)
          .update(updatedPortfolio.toJson());
    } catch (e) {
      throw Exception('포트폴리오 업데이트 실패: $e');
    }
  }

  Future<void> deletePortfolio(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('포트폴리오 삭제 실패: $e');
    }
  }

  Stream<List<PortfolioModel>> watchPortfolios() {
    return _firestore
        .collection(_collection)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PortfolioModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<PortfolioModel>> watchPortfoliosByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PortfolioModel.fromJson(doc.data()))
            .toList());
  }
}
