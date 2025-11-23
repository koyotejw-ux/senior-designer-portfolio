import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/ui_settings_repository.dart';
import '../../domain/models/ui_settings_model.dart';

// Repository Provider
final uiSettingsRepositoryProvider = Provider<UiSettingsRepository>((ref) {
  return UiSettingsRepository();
});

// Settings State Provider
final uiSettingsProvider = StateNotifierProvider<UiSettingsNotifier, AsyncValue<UiSettingsModel>>((ref) {
  return UiSettingsNotifier(
    repository: ref.watch(uiSettingsRepositoryProvider),
  );
});

class UiSettingsNotifier extends StateNotifier<AsyncValue<UiSettingsModel>> {
  final UiSettingsRepository repository;

  UiSettingsNotifier({
    required this.repository,
  }) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  /// 설정 불러오기
  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await repository.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 설정 새로고침
  Future<void> refresh() async {
    await _loadSettings();
  }

  /// Resume 페이지 간격 업데이트
  Future<void> updateResumeSpacing(PageSpacing spacing) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    try {
      final updatedSettings = currentSettings.copyWith(
        resumeSpacing: spacing,
      );
      await repository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Portfolio 페이지 간격 업데이트
  Future<void> updatePortfolioSpacing(PageSpacing spacing) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    try {
      final updatedSettings = currentSettings.copyWith(
        portfolioSpacing: spacing,
      );
      await repository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Documents 페이지 간격 업데이트
  Future<void> updateDocumentsSpacing(PageSpacing spacing) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    try {
      final updatedSettings = currentSettings.copyWith(
        documentsSpacing: spacing,
      );
      await repository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 모든 설정 한번에 업데이트
  Future<void> updateAllSpacings({
    required PageSpacing resumeSpacing,
    required PageSpacing portfolioSpacing,
    required PageSpacing documentsSpacing,
  }) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    try {
      final updatedSettings = currentSettings.copyWith(
        resumeSpacing: resumeSpacing,
        portfolioSpacing: portfolioSpacing,
        documentsSpacing: documentsSpacing,
      );
      await repository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
