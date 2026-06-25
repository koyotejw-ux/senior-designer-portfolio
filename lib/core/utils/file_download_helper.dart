import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class FileDownloadHelper {
  /// Downloads a file on Web by creating a Blob URL and triggering an anchor click.
  /// It keeps the anchor element in the DOM and keeps the Blob URL alive for a short
  /// delay (e.g., 15 seconds) to ensure that the browser (specifically Chrome) has
  /// enough time to resolve the download metadata and apply the correct filename.
  static void downloadFile({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/octet-stream',
  }) {
    if (!kIsWeb) return;
    try {
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = fileName
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();

      // Delay removal and revocation to prevent Chrome from ignoring the filename
      // or canceling the download.
      Future.delayed(const Duration(seconds: 15), () {
        try {
          anchor.remove();
          html.Url.revokeObjectUrl(url);
        } catch (_) {}
      });
    } catch (e) {
      debugPrint('Error downloading file: $e');
    }
  }
}
