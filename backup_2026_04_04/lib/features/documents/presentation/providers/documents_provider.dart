import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/documents_repository.dart';
import '../../domain/models/document_model.dart';

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  return DocumentsRepository();
});

final documentsProvider = FutureProvider<List<DocumentModel>>((ref) async {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getDocuments();
});

final documentsNotifierProvider =
    StateNotifierProvider<DocumentsNotifier, AsyncValue<void>>((ref) {
      return DocumentsNotifier(
        repository: ref.watch(documentsRepositoryProvider),
        ref: ref,
      );
    });

class DocumentsNotifier extends StateNotifier<AsyncValue<void>> {
  final DocumentsRepository repository;
  final Ref ref;

  DocumentsNotifier({required this.repository, required this.ref})
    : super(const AsyncValue.data(null));

  Future<void> createDocument({
    required DocumentType type,
    required String title,
    required Map<String, dynamic> content,
    String? pdfUrl,
    List<String>? tags,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.createDocument(
        type: type,
        title: title,
        content: content,
        pdfUrl: pdfUrl,
        tags: tags,
      );
      ref.invalidate(documentsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateDocument(DocumentModel document) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateDocument(document);
      ref.invalidate(documentsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteDocument(String id) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteDocument(id);
      ref.invalidate(documentsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
