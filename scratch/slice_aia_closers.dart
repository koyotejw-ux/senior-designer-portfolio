import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  print('Starting image processing...');
  
  sliceImage('assets/images/aia.jpg', 'aia', 6);
  sliceImage('assets/images/closers.jpg', 'closers', 3);

  print('All image processing complete!');
}

void sliceImage(String inputPath, String prefix, int parts) {
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('Error: Input file does not exist at $inputPath');
    return;
  }
  
  final bytes = file.readAsBytesSync();
  final image = img.decodeImage(bytes);
  if (image == null) {
    print('Error: Failed to decode image from $inputPath');
    return;
  }

  final int sliceHeight = (image.height / parts).ceil();
  print('Slicing $inputPath (${image.width}x${image.height}) into $parts parts (height: ~${sliceHeight}px)...');

  for (int i = 0; i < parts; i++) {
    final int y = i * sliceHeight;
    int currentSliceHeight = sliceHeight;
    if (y + currentSliceHeight > image.height) {
      currentSliceHeight = image.height - y;
    }

    if (currentSliceHeight <= 0) break;

    final slice = img.copyCrop(
      image,
      x: 0,
      y: y,
      width: image.width,
      height: currentSliceHeight,
    );

    final outputPath = 'assets/images/${prefix}_${i + 1}.jpg';
    File(outputPath).writeAsBytesSync(img.encodeJpg(slice, quality: 90));
    print('Saved slice: $outputPath (${image.width}x$currentSliceHeight)');
  }
}
