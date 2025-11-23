import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../domain/models/portfolio_model.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return PortfolioRepository();
});

final portfoliosProvider = StreamProvider<List<PortfolioModel>>((ref) {
  final repository = ref.watch(portfolioRepositoryProvider);
  return repository.watchPortfolios();
});

final portfoliosNotifierProvider = StateNotifierProvider<PortfoliosNotifier, AsyncValue<void>>((ref) {
  return PortfoliosNotifier(
    repository: ref.watch(portfolioRepositoryProvider),
  );
});

class PortfoliosNotifier extends StateNotifier<AsyncValue<void>> {
  final PortfolioRepository repository;

  PortfoliosNotifier({
    required this.repository,
  }) : super(const AsyncValue.data(null));

  Future<void> createPortfolio(PortfolioModel portfolio) async {
    state = const AsyncValue.loading();
    try {
      await repository.createPortfolio(portfolio);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    state = const AsyncValue.loading();
    try {
      await repository.updatePortfolio(portfolio);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deletePortfolio(String id) async {
    state = const AsyncValue.loading();
    try {
      await repository.deletePortfolio(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
