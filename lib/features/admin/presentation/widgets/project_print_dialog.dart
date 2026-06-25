import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

import '../../../../core/utils/file_download_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/project_model.dart';

/// Represents an intro image entry that can be toggled on/off and replaced
class _IntroImageEntry {
  String assetPath;
  bool selected;
  Uint8List? customBytes; // If user uploaded a replacement

  _IntroImageEntry({
    required this.assetPath,
    this.selected = true,
    this.customBytes,
  });

  String get label {
    final name = assetPath.split('/').last;
    return name;
  }
}

class ProjectPrintDialog extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectPrintDialog({super.key, required this.projects});

  @override
  State<ProjectPrintDialog> createState() => _ProjectPrintDialogState();
}

class _ProjectPrintDialogState extends State<ProjectPrintDialog> {
  late List<ProjectModel> _orderedProjects;
  late List<bool> _projectSelected;
  bool _isProcessing = false;
  String _statusMessage = '';
  double _progress = 0.0;

  final TextEditingController _widthController = TextEditingController(
    text: '1920',
  );
  double _quality = 8.0;

  Uint8List? _finalBytes;
  String? _blobUrl;

  // Intro images with individual toggle and upload
  late List<_IntroImageEntry> _introEntries;

  @override
  void initState() {
    super.initState();
    _orderedProjects = List.from(widget.projects);
    _projectSelected = List.filled(widget.projects.length, true);
    _introEntries = [
      _IntroImageEntry(assetPath: 'assets/images/int_01.jpg'),
      _IntroImageEntry(assetPath: 'assets/images/int_02.png'),
      _IntroImageEntry(assetPath: 'assets/images/int_03.jpg'),
    ];
  }

  @override
  void dispose() {
    _widthController.dispose();
    if (_blobUrl != null) {
      try {
        html.Url.revokeObjectUrl(_blobUrl!);
      } catch (_) {}
    }
    super.dispose();
  }

  /// Upload a replacement image for an intro slot
  Future<void> _uploadIntroImage(int index) async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;
    if (uploadInput.files == null || uploadInput.files!.isEmpty) return;

    final file = uploadInput.files!.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    if (reader.result != null) {
      final bytes = Uint8List.fromList(reader.result as List<int>);
      setState(() {
        _introEntries[index].customBytes = bytes;
      });
    }
  }

  /// Load image bytes from asset path or custom upload
  Future<Uint8List?> _loadIntroImageBytes(_IntroImageEntry entry) async {
    if (entry.customBytes != null) return entry.customBytes;
    try {
      final data = await rootBundle.load(entry.assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error loading intro image ${entry.assetPath}: $e');
      return null;
    }
  }

  /// Load image bytes from a path (asset or http)
  Future<Uint8List?> _loadImageBytes(String imagePath) async {
    try {
      if (imagePath.startsWith('http')) {
        final resp = await http.get(Uri.parse(imagePath));
        if (resp.statusCode != 200) {
          debugPrint('HTTP Error ${resp.statusCode} for $imagePath');
          return null;
        }
        return resp.bodyBytes;
      } else {
        final data = await rootBundle.load(imagePath);
        return data.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint('Error loading image $imagePath: $e');
      return null;
    }
  }

  Future<void> _processPdf() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Starting...';
      _progress = 0.0;
      _finalBytes = null;
    });

    try {
      double targetW = 1920.0;
      final wInput = double.tryParse(_widthController.text);
      if (wInput != null && wInput > 0) targetW = wInput;
      final int targetWInt = targetW.toInt();

      final isLossless = _quality >= 10.0;
      final jpgQuality = (_quality * 10).toInt().clamp(10, 90);

      // 1. Count total items
      int totalItems = 0;
      for (final entry in _introEntries) {
        if (entry.selected) totalItems++;
      }
      for (int i = 0; i < _orderedProjects.length; i++) {
        if (!_projectSelected[i]) continue;
        final project = _orderedProjects[i];
        totalItems += (project.mainScreenImages.isNotEmpty
                ? project.mainScreenImages
                : (project.imageUrl != null ? [project.imageUrl!] : []))
            .length;
      }
      if (totalItems == 0) throw Exception('No items selected.');

      int processedItems = 0;

      // 2. Load all images resized to targetW
      final List<img.Image> allImages = [];

      img.Image resizeTo(img.Image src) {
        if (src.width == targetWInt) return src;
        final interp = targetWInt > src.width
            ? img.Interpolation.cubic
            : img.Interpolation.average;
        return img.copyResize(src, width: targetWInt, interpolation: interp);
      }

      // Intro images
      for (final entry in _introEntries) {
        if (!entry.selected) continue;
        setState(() {
          _statusMessage = 'Loading intro: ${entry.label}';
          _progress = processedItems / totalItems * 0.75;
        });
        await Future.delayed(const Duration(milliseconds: 30));
        final bytes = await _loadIntroImageBytes(entry);
        if (bytes != null) {
          final decoded = img.decodeImage(bytes);
          if (decoded != null) allImages.add(resizeTo(decoded));
        }
        processedItems++;
      }

      // Portfolio images
      for (int i = 0; i < _orderedProjects.length; i++) {
        if (!_projectSelected[i]) continue;
        final project = _orderedProjects[i];
        final paths = project.mainScreenImages.isNotEmpty
            ? project.mainScreenImages
            : (project.imageUrl != null ? [project.imageUrl!] : <String>[]);

        for (int j = 0; j < paths.length; j++) {
          setState(() {
            _statusMessage =
                'Loading: ${project.title} (${j + 1}/${paths.length})';
            _progress = processedItems / totalItems * 0.75;
          });
          await Future.delayed(const Duration(milliseconds: 30));
          final bytes = await _loadImageBytes(paths[j]);
          if (bytes != null) {
            final decoded = img.decodeImage(bytes);
            if (decoded != null) allImages.add(resizeTo(decoded));
          }
          processedItems++;
        }
      }

      if (allImages.isEmpty) throw Exception('No images could be loaded.');

      // 3. Calculate cumulative Y start positions
      final List<int> imageStartY = [];
      int cumY = 0;
      for (final im in allImages) {
        imageStartY.add(cumY);
        cumY += im.height;
      }
      final int totalH = cumY;

      // 4. Build PDF pages via canvas compositing (zero gaps guaranteed)
      const int maxPageH = 14000;
      final pdf = pw.Document();
      int pageStartY = 0;
      int pageIndex = 0;
      final int totalPages = ((totalH - 1) ~/ maxPageH) + 1;

      while (pageStartY < totalH) {
        final int pageH = (totalH - pageStartY).clamp(1, maxPageH);
        final int pageEndY = pageStartY + pageH;

        setState(() {
          _statusMessage = 'Building page ${pageIndex + 1}/$totalPages...';
          _progress = 0.75 + 0.2 * pageIndex / totalPages;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        // White-filled canvas for this page (투명 배경 → 흰색 배경으로 간격 방지)
        final canvas = img.Image(width: targetWInt, height: pageH);
        img.fill(canvas, color: img.ColorRgba8(255, 255, 255, 255));

        // Composite every overlapping image slice at exact pixel positions
        // BlendMode.direct: 알파 블렌딩 없이 픽셀 직접 복사 → 이미지 경계 간격 제거
        for (int i = 0; i < allImages.length; i++) {
          final imgStart = imageStartY[i];
          final imgEnd = imgStart + allImages[i].height;
          if (imgEnd <= pageStartY || imgStart >= pageEndY) continue;

          final overlapStart = imgStart < pageStartY ? pageStartY : imgStart;
          final overlapEnd = imgEnd > pageEndY ? pageEndY : imgEnd;
          final sliceH = overlapEnd - overlapStart;
          if (sliceH <= 0) continue;

          final srcY = overlapStart - imgStart;
          final dstY = overlapStart - pageStartY;

          final slice = img.copyCrop(
            allImages[i],
            x: 0,
            y: srcY,
            width: targetWInt,
            height: sliceH,
          );
          img.compositeImage(canvas, slice, dstX: 0, dstY: dstY,
              blend: img.BlendMode.direct);
        }

        // Encode merged canvas as a single image
        final Uint8List pageBytes = isLossless
            ? Uint8List.fromList(img.encodePng(canvas))
            : Uint8List.fromList(img.encodeJpg(canvas, quality: jpgQuality));

        // One image per PDF page — no layout engine, no gaps
        final capturedH = pageH;
        final capturedBytes = pageBytes;
        pdf.addPage(
          pw.Page(
            pageFormat:
                PdfPageFormat(targetW, capturedH.toDouble(), marginAll: 0),
            margin: pw.EdgeInsets.zero,
            build: (ctx) => pw.Image(
              pw.MemoryImage(capturedBytes),
              width: targetW,
              height: capturedH.toDouble(),
              fit: pw.BoxFit.fill,
            ),
          ),
        );

        pageStartY = pageEndY;
        pageIndex++;
      }

      // 5. Save PDF
      setState(() {
        _statusMessage = 'Finalizing PDF...';
        _progress = 0.98;
      });
      await Future.delayed(const Duration(milliseconds: 100));

      final pdfBytes = await pdf.save();

      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Complete!';
          _finalBytes = pdfBytes;
          _blobUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Error: $e';
        });
      }
    }
  }

  void _download() {
    if (_finalBytes == null) return;
    FileDownloadHelper.downloadFile(
      bytes: _finalBytes!,
      fileName: 'portfolio_master.pdf',
      mimeType: 'application/pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepSpace,
      child: Container(
        width: 600,
        height: 720,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Export Portfolio PDF',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isProcessing
                  ? _buildProcessingView()
                  : _finalBytes != null
                      ? _buildCompleteView()
                      : _buildConfigView(),
            ),
            if (!_isProcessing && _finalBytes == null) ...[
              const Divider(color: Colors.white24, height: 32),
              _buildBottomControls(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  color: AppColors.primaryBlue,
                  strokeWidth: 3,
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: AppColors.highlightGreen, size: 80),
          const SizedBox(height: 20),
          const Text(
            'PDF Ready!',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 8),
          if (_finalBytes != null)
            Text(
              '${(_finalBytes!.length / 1024 / 1024).toStringAsFixed(1)} MB',
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Download Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.highlightGreen,
              foregroundColor: Colors.black,
              minimumSize: const Size(200, 60),
            ),
            onPressed: _download,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigView() {
    return ListView(
      children: [
        // --- Intro Images Section ---
        const Text(
          'INTRO PAGES',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_introEntries.length, (i) {
          final entry = _introEntries[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: entry.selected
                  ? AppColors.primaryBlue.withValues(alpha: 0.1)
                  : AppColors.charcoal.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: entry.selected
                    ? AppColors.primaryBlue.withValues(alpha: 0.3)
                    : Colors.white10,
              ),
            ),
            child: ListTile(
              dense: true,
              leading: Checkbox(
                value: entry.selected,
                onChanged: (v) =>
                    setState(() => _introEntries[i].selected = v ?? false),
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.customBytes != null
                          ? '${entry.label} (커스텀)'
                          : entry.label,
                      style: TextStyle(
                        color: entry.selected ? Colors.white : Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (entry.customBytes != null)
                    IconButton(
                      icon: const Icon(Icons.restore, size: 16),
                      color: Colors.orange,
                      tooltip: '원본으로 복원',
                      onPressed: () =>
                          setState(() => _introEntries[i].customBytes = null),
                    ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.upload_file, size: 18),
                color: Colors.white54,
                tooltip: '이미지 교체',
                onPressed: () => _uploadIntroImage(i),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // --- Project List Section ---
        const Text(
          'PORTFOLIO PROJECTS',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            TextButton.icon(
              icon: const Icon(Icons.select_all, size: 14),
              label: const Text('All', style: TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(foregroundColor: Colors.white54),
              onPressed: () =>
                  setState(() => _projectSelected.fillRange(0, _projectSelected.length, true)),
            ),
            TextButton.icon(
              icon: const Icon(Icons.deselect, size: 14),
              label: const Text('None', style: TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(foregroundColor: Colors.white54),
              onPressed: () =>
                  setState(() => _projectSelected.fillRange(0, _projectSelected.length, false)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) newIndex--;
            setState(() {
              final project = _orderedProjects.removeAt(oldIndex);
              final selected = _projectSelected.removeAt(oldIndex);
              _orderedProjects.insert(newIndex, project);
              _projectSelected.insert(newIndex, selected);
            });
          },
          children: [
            for (int i = 0; i < _orderedProjects.length; i++)
              Container(
                key: ValueKey(_orderedProjects[i].id),
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: _projectSelected[i]
                      ? AppColors.primaryBlue.withValues(alpha: 0.08)
                      : AppColors.charcoal.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListTile(
                  dense: true,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _projectSelected[i],
                        onChanged: (v) =>
                            setState(() => _projectSelected[i] = v ?? false),
                        activeColor: AppColors.primaryBlue,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                      ),
                      const Icon(Icons.drag_handle, color: Colors.white24, size: 18),
                    ],
                  ),
                  title: Text(
                    _orderedProjects[i].title,
                    style: TextStyle(
                      color: _projectSelected[i] ? Colors.white : Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${_orderedProjects[i].mainScreenImages.length} images',
                    style: TextStyle(
                      color: _projectSelected[i]
                          ? Colors.white30
                          : Colors.white12,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _widthController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Width (px)',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.charcoal,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quality: ${_quality.toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  Slider(
                    value: _quality,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (v) => setState(() => _quality = v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('Generate PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 44),
              ),
              onPressed: _processPdf,
            ),
          ],
        ),
      ],
    );
  }
}
