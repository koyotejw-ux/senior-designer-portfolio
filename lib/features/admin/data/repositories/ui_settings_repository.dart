import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/ui_settings_model.dart';

class UiSettingsRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'settings';
  static const String _documentId = 'ui_settings';

  UiSettingsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// UI 설정 불러오기
  Future<UiSettingsModel> getSettings() async {
    try {
      final doc = await _firestore.collection(_collection).doc(_documentId).get();

      if (doc.exists && doc.data() != null) {
        return UiSettingsModel.fromJson(doc.data()!);
      }

      // 설정이 없으면 기본값 반환
      return UiSettingsModel.defaultSettings();
    } catch (e) {
      // 오류 시 기본값 반환
      return UiSettingsModel.defaultSettings();
    }
  }

  /// UI 설정 저장하기
  Future<void> saveSettings(UiSettingsModel settings) async {
    try {
      final updatedSettings = settings.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(_documentId)
          .set(updatedSettings.toJson());
    } catch (e) {
      throw Exception('설정 저장에 실패했습니다: $e');
    }
  }

  /// UI 설정 실시간 구독
  Stream<UiSettingsModel> watchSettings() {
    return _firestore
        .collection(_collection)
        .doc(_documentId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UiSettingsModel.fromJson(doc.data()!);
      }
      return UiSettingsModel.defaultSettings();
    });
  }
}
