import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Dart Uint8List를 JS Uint8Array로 직접 넘겨 Blob → anchor download 처리.
/// Base64 인코딩을 사용하지 않으므로 크롬에서 대용량 PDF도 안정적으로 다운로드됩니다.
@JS('downloadFileFromBytes')
external void _downloadFileFromBytes(
  JSUint8Array bytesArray,
  JSString fileName,
  JSString mimeType,
);

class FileDownloadHelper {
  static void downloadFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/pdf',
  }) {
    if (!kIsWeb) return;

    try {
      // Uint8List → JSUint8Array 직접 변환 (Base64 없음, 메모리 효율적)
      final jsBytes = bytes.toJS;
      _downloadFileFromBytes(
        jsBytes,
        fileName.toJS,
        mimeType.toJS,
      );
    } catch (e) {
      debugPrint('FileDownloadHelper error: $e');
    }
  }
}
