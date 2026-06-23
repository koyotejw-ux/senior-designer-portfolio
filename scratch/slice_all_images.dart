import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  print('Starting image processing...');
  
  // 1. Generate thumbnails
  generateThumbnail('assets/images/ht_01.jpg', 'assets/images/ht_thumbnail.jpg');
  generateThumbnail('assets/images/hthome_01_1.jpg', 'assets/images/hthome_thumbnail.jpg');

  // 2. Slice Wallpad & HT Home images
  sliceImage('assets/images/ht_01.jpg', 'ht_01', 6);
  sliceImage('assets/images/ht_02_1.jpg', 'ht_02_1', 4);
  sliceImage('assets/images/ht_02_2.jpg', 'ht_02_2', 4);
  sliceImage('assets/images/ht_03_1.jpg', 'ht_03_1', 4);
  sliceImage('assets/images/ht_03_2.jpg', 'ht_03_2', 4);

  sliceImage('assets/images/hthome_01_1.jpg', 'hthome_01_1', 4);
  sliceImage('assets/images/hthome_01_2.jpg', 'hthome_01_2', 4);
  sliceImage('assets/images/hthome_01_3.jpg', 'hthome_01_3', 4);

  print('All image processing complete!');
}

void generateThumbnail(String inputPath, String outputPath) {
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

  // Crop top 1920x1080 area
  final thumbnail = img.copyCrop(image, x: 0, y: 0, width: image.width, height: (image.height > 1080) ? 1080 : image.height);
  
  // Save thumbnail
  File(outputPath).writeAsBytesSync(img.encodeJpg(thumbnail, quality: 85));
  print('Generated thumbnail at $outputPath');
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

    final outputPath = 'assets/images/${prefix}_slice_${i + 1}.jpg';
    File(outputPath).writeAsBytesSync(img.encodeJpg(slice, quality: 90));
    print('Saved slice: $outputPath (${image.width}x$currentSliceHeight)');
  }
}
