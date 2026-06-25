// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
import 'package:flutter/foundation.dart';

/// JS interop 선언: window.savePdfFile(uint8Array, fileName, mimeType)
@JS('savePdfFile')
external void _savePdfFile(JSUint8Array bytes, JSString fileName, JSString mimeType);

/// Web 전용 파일 다운로드 헬퍼.
///
/// web/index.html에 삽입된 FileSaver.js 기반의 `savePdfFile` JS 함수를
/// dart:js_interop으로 직접 호출합니다.
///
/// Chrome 등 최신 브라우저에서 Blob URL이 UUID 파일명으로 저장되는 오류를
/// 완벽하게 해결합니다.
class FileDownloadHelper {
  static void downloadFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/pdf',
  }) {
    if (!kIsWeb) return;

    try {
      // Dart Uint8List → JavaScript Uint8Array 변환
      final jsBytes = bytes.toJS;
      _savePdfFile(jsBytes, fileName.toJS, mimeType.toJS);
    } catch (e) {
      debugPrint('FileDownloadHelper JS interop error: $e');
    }
  }
}
