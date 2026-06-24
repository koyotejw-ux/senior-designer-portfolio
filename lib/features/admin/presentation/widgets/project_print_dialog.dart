import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/project_model.dart';

class ProjectPrintDialog extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectPrintDialog({super.key, required this.projects});

  @override
  State<ProjectPrintDialog> createState() => _ProjectPrintDialogState();
}

class _ProjectPrintDialogState extends State<ProjectPrintDialog> {
  late List<ProjectModel> _orderedProjects;
  bool _isProcessing = false;
  String _statusMessage = '';

  final TextEditingController _widthController = TextEditingController(
    text: '1920',
  );
  double _quality = 8.0;

  Uint8List? _finalBytes;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    _orderedProjects = List.from(widget.projects);
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

  Future<void> _processPdf() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Starting Engine...';
      _finalBytes = null;
    });

    try {
      final pdf = pw.Document();

      double targetW = 1920.0;
      final wInput = double.tryParse(_widthController.text);
      if (wInput != null && wInput > 0) targetW = wInput;

      final isLossless = _quality >= 10.0;
      final jpgQuality = (_quality * 10).toInt().clamp(10, 90);

      // 모든 프로젝트 이미지를 하나로 합치기 위한 리스트
      List<img.Image> allDecodedImages = [];

      // Step 1: 모든 프로젝트 이미지 다운로드 및 디코딩
      final introImages = [
        'assets/images/int_01.jpg',
        'assets/images/int_02.png',
        'assets/images/int_03.jpg',
      ];

      for (int i = 0; i < introImages.length; i++) {
        setState(() {
          _statusMessage = 'Loading Intro Image ${i + 1}/${introImages.length}';
        });
        await Future.delayed(const Duration(milliseconds: 50));
        try {
          final ByteData data = await rootBundle.load(introImages[i]);
          final rawBytes = data.buffer.asUint8List();
          img.Image? decoded = img.decodeImage(rawBytes);
          if (decoded != null) {
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
            allDecodedImages.add(decoded);
          }
        } catch (e) {
          debugPrint('Error loading intro image ${introImages[i]}: $e');
        }
      }

      for (int i = 0; i < _orderedProjects.length; i++) {
        final project = _orderedProjects[i];
        final imagesToProcess = project.mainScreenImages.isNotEmpty 
            ? project.mainScreenImages 
            : (project.imageUrl != null ? [project.imageUrl!] : []);

        for (int j = 0; j < imagesToProcess.length; j++) {
          final imagePath = imagesToProcess[j];
          setState(() {
            _statusMessage =
                'Loading ${i + 1}/${_orderedProjects.length}\n${project.title} (${j + 1}/${imagesToProcess.length})';
          });
          await Future.delayed(const Duration(milliseconds: 50));

          try {
            Uint8List rawBytes;
            if (imagePath.startsWith('http')) {
              final resp = await http.get(Uri.parse(imagePath));
              if (resp.statusCode != 200) {
                debugPrint('HTTP Error ${resp.statusCode} for $imagePath');
                continue;
              }
              rawBytes = resp.bodyBytes;
            } else {
              // It's a local asset
              final ByteData data = await rootBundle.load(imagePath);
              rawBytes = data.buffer.asUint8List();
            }

            img.Image? decoded = img.decodeImage(rawBytes);
            if (decoded == null) {
              debugPrint('Failed to decode image: $imagePath');
              continue;
            }

            // Resize to target width
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

            allDecodedImages.add(decoded);
          } catch (e) {
            debugPrint('Error processing ${project.title} ($imagePath): $e');
          }
        }
      }

      if (allDecodedImages.isEmpty) {
        throw Exception('No valid images to process.');
      }

      setState(() {
        _statusMessage = 'Merging images...';
      });
      await Future.delayed(Duration(milliseconds: 100));

      // Step 2: 모든 이미지를 수직으로 하나의 큰 이미지로 합치기
      int totalHeight = 0;
      for (var img in allDecodedImages) {
        totalHeight += img.height;
      }

      final mergedImage = img.Image(
        width: targetW.toInt(),
        height: totalHeight,
      );

      int currentY = 0;
      for (var image in allDecodedImages) {
        img.compositeImage(
          mergedImage,
          image,
          dstX: 0,
          dstY: currentY,
        );
        currentY += image.height;
      }

      setState(() {
        _statusMessage = 'Creating PDF...';
      });
      await Future.delayed(Duration(milliseconds: 100));

      // Step 3: 전체 이미지를 하나의 긴 PDF 페이지로 생성 (간격 없음)
      Uint8List finalImageBytes;
      if (isLossless) {
        finalImageBytes = Uint8List.fromList(img.encodePng(mergedImage));
      } else {
        finalImageBytes = Uint8List.fromList(
          img.encodeJpg(mergedImage, quality: jpgQuality),
        );
      }

      // 전체 높이를 하나의 페이지로 생성 (간격 완전 제거)
      final double totalHeightPt = mergedImage.height.toDouble();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            targetW,
            totalHeightPt,
            marginAll: 0,
          ),
          margin: pw.EdgeInsets.zero,
          build: (ctx) => pw.Image(
            pw.MemoryImage(finalImageBytes),
            width: targetW,
            height: totalHeightPt,
            fit: pw.BoxFit.fill,
            dpi: 72,
          ),
        ),
      );

      // PDF should have at least one page if we got this far

      setState(() {
        _statusMessage = 'Finalizing...';
      });
      await Future.delayed(Duration(milliseconds: 100));

      final bytes = await pdf.save();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Complete!';
          _finalBytes = bytes;
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

  void _download() {
    if (_blobUrl == null) return;
    final anchor = html.AnchorElement(href: _blobUrl)
      ..setAttribute('download', 'portfolio_master.pdf')
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepSpace,
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Export Portfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isProcessing
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  : _finalBytes != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.highlightGreen,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'PDF Ready!',
                            style: TextStyle(color: Colors.white, fontSize: 24),
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
                    )
                  : ReorderableListView(
                      onReorder: (o, n) {
                        if (o < n) n--;
                        setState(
                          () => _orderedProjects.insert(
                            n,
                            _orderedProjects.removeAt(o),
                          ),
                        );
                      },
                      children: [
                        for (final p in _orderedProjects)
                          ListTile(
                            key: ValueKey(p.id),
                            title: Text(
                              p.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(
                              Icons.drag_handle,
                              color: Colors.white38,
                            ),
                            tileColor: AppColors.charcoal.withValues(
                              alpha: 0.5,
                            ),
                          ),
                      ],
                    ),
            ),

            if (!_isProcessing && _finalBytes == null) ...[
              const Divider(color: Colors.white24, height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _widthController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Page Width (Points)',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: AppColors.charcoal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quality: ${_quality.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
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
              const SizedBox(height: 30),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _processPdf,
                    child: const Text('Generate PDF'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
