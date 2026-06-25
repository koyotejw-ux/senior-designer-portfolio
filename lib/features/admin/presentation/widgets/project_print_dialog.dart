import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

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
      final pdf = pw.Document();

      double targetW = 1920.0;
      final wInput = double.tryParse(_widthController.text);
      if (wInput != null && wInput > 0) targetW = wInput;

      final isLossless = _quality >= 10.0;
      final jpgQuality = (_quality * 10).toInt().clamp(10, 90);

      // Calculate total work items for progress
      int totalItems = 0;
      for (final entry in _introEntries) {
        if (entry.selected) totalItems++;
      }
      for (int i = 0; i < _orderedProjects.length; i++) {
        if (!_projectSelected[i]) continue;
        final project = _orderedProjects[i];
        final images = project.mainScreenImages.isNotEmpty
            ? project.mainScreenImages
            : (project.imageUrl != null ? [project.imageUrl!] : []);
        totalItems += images.length;
      }

      if (totalItems == 0) {
        throw Exception('No items selected.');
      }

      int processedItems = 0;

      // Max page height in pixels (to split tall images)
      // Using a reasonable max height per PDF page
      final int maxPageHeightPx = (targetW * 1.414).toInt(); // ~A4 ratio

      List<pw.Widget> currentPageWidgets = [];
      double currentPageHeight = 0;
      final double maxPdfPageHeight = 14000.0; // PDF format safe limit

      /// Helper: decode bytes -> resize to targetW -> split -> pack into pages
      void addImageToPdf(Uint8List rawBytes, String label) {
        img.Image? decoded = img.decodeImage(rawBytes);
        if (decoded == null) {
          debugPrint('Failed to decode image: $label');
          return;
        }

        if (decoded.width != targetW.toInt()) {
          var interp = targetW > decoded.width
              ? img.Interpolation.cubic
              : img.Interpolation.average;
          decoded = img.copyResize(
            decoded,
            width: targetW.toInt(),
            interpolation: interp,
          );
        }

        int remainingY = 0;
        while (remainingY < decoded.height) {
          int chunkH = (decoded.height - remainingY).clamp(1, maxPageHeightPx);

          final chunk = img.copyCrop(
            decoded,
            x: 0,
            y: remainingY,
            width: decoded.width,
            height: chunkH,
          );

          Uint8List chunkBytes;
          if (isLossless) {
            chunkBytes = Uint8List.fromList(img.encodePng(chunk));
          } else {
            chunkBytes = Uint8List.fromList(
              img.encodeJpg(chunk, quality: jpgQuality),
            );
          }

          // Check if adding this chunk exceeds the max page height
          if (currentPageHeight + chunkH > maxPdfPageHeight && currentPageWidgets.isNotEmpty) {
            // Flush current page
            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat(targetW, currentPageHeight, marginAll: 0),
                margin: pw.EdgeInsets.zero,
                build: (ctx) => pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: List.from(currentPageWidgets),
                ),
              ),
            );
            currentPageWidgets.clear();
            currentPageHeight = 0;
          }

          currentPageWidgets.add(
            pw.Image(
              pw.MemoryImage(chunkBytes),
              width: targetW,
              height: chunkH.toDouble(),
              fit: pw.BoxFit.fill,
            ),
          );
          currentPageHeight += chunkH.toDouble();
          remainingY += chunkH;
        }
      }

      // --- STEP 1: Process selected intro images ---
      for (int i = 0; i < _introEntries.length; i++) {
        final entry = _introEntries[i];
        if (!entry.selected) continue;

        setState(() {
          _statusMessage = 'Loading Intro: ${entry.label}';
          _progress = processedItems / totalItems;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        final bytes = await _loadIntroImageBytes(entry);
        if (bytes != null) {
          addImageToPdf(bytes, entry.label);
        }
        processedItems++;
      }

      // --- STEP 2: Process selected project images ---
      for (int i = 0; i < _orderedProjects.length; i++) {
        if (!_projectSelected[i]) continue;

        final project = _orderedProjects[i];
        final imagePaths = project.mainScreenImages.isNotEmpty
            ? project.mainScreenImages
            : (project.imageUrl != null ? [project.imageUrl!] : []);

        for (int j = 0; j < imagePaths.length; j++) {
          final imagePath = imagePaths[j];

          setState(() {
            _statusMessage =
                'Loading: ${project.title}\n(${j + 1}/${imagePaths.length})';
            _progress = processedItems / totalItems;
          });
          await Future.delayed(const Duration(milliseconds: 30));

          final bytes = await _loadImageBytes(imagePath);
          if (bytes != null) {
            addImageToPdf(bytes, '${project.title} - $imagePath');
          }
          processedItems++;
        }
      }

      if (currentPageWidgets.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(targetW, currentPageHeight, marginAll: 0),
            margin: pw.EdgeInsets.zero,
            build: (ctx) => pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: List.from(currentPageWidgets),
            ),
          ),
        );
      }

      setState(() {
        _statusMessage = 'Finalizing PDF...';
        _progress = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 100));

      final pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Complete!';
          _finalBytes = pdfBytes;
          _blobUrl = url;
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

  void _download() async {
    if (_finalBytes == null) return;
    await Printing.sharePdf(bytes: _finalBytes!, filename: 'portfolio_master.pdf');
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
