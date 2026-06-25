import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// web/index.html의 downloadFileFromBase64(base64, fileName, mimeType) 함수를 바인딩합니다.
@JS('downloadFileFromBase64')
external void _downloadFileFromBase64(
  JSString base64Data,
  JSString fileName,
  JSString mimeType,
);

/// Web 전용 파일 다운로드 헬퍼.
///
/// Dart [Uint8List] → Base64 문자열 → JavaScript 함수 호출 경로를 사용합니다.
/// 바이너리 데이터를 Dart↔JS 경계에서 직접 넘기는 대신 Base64 문자열을 사용하므로
/// 데이터 손실이나 타입 변환 오류가 발생하지 않습니다.
class FileDownloadHelper {
  static void downloadFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/pdf',
  }) {
    if (!kIsWeb) return;

    try {
      // Uint8List → Base64 문자열 변환
      final base64Data = base64Encode(bytes);

      // index.html에 정의된 순수 JS 함수 호출
      _downloadFileFromBase64(
        base64Data.toJS,
        fileName.toJS,
        mimeType.toJS,
      );
    } catch (e) {
      debugPrint('FileDownloadHelper error: $e');
    }
  }
}
