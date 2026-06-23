import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final dir = Directory('assets/images');
  for (var file in dir.listSync()) {
    if (file is File && (file.path.endsWith('.jpg') || file.path.endsWith('.png'))) {
      final bytes = file.readAsBytesSync();
      final image = img.decodeImage(bytes);
      if (image != null) {
        print('${file.path.split(Platform.pathSeparator).last}: ${image.width}x${image.height}');
      }
    }
  }
}
