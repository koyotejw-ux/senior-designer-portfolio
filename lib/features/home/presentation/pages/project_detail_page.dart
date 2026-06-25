import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../core/utils/file_download_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/content_provider.dart';
import '../widgets/floating_dots_background.dart';
import '../widgets/web_optimized_image.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  final GlobalKey _imageKey = GlobalKey();
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollButton) {
        setState(() => _showScrollButton = true);
      } else if (_scrollController.offset <= 300 && _showScrollButton) {
        setState(() => _showScrollButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _downloadAsPdf(String imageUrl, String projectTitle) async {
    if (mounted) {
      _isDownloading = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('다운로드가 백그라운드에서 시작되었습니다. 잠시만 기다려주세요...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      // Fetch image data

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Decoding

      final decodedImage = img.decodeImage(response.bodyBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }

      final imageWidth = decodedImage.width.toDouble();
      final imageHeight = decodedImage.height.toDouble();
      final imageAspectRatio = imageWidth / imageHeight;

      final baseWidth = PdfPageFormat.a4.width;
      final customHeight = baseWidth / imageAspectRatio;

      final pageFormat = PdfPageFormat(baseWidth, customHeight, marginAll: 0);

      // Creating PDF
      // if (mounted) setState(() => _downloadProgress = 0.7);

      final pdf = pw.Document();
      final image = pw.MemoryImage(response.bodyBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Image(image, fit: pw.BoxFit.fill);
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();

      // Download
      FileDownloadHelper.downloadFile(
        bytes: pdfBytes,
        fileName: '${projectTitle.replaceAll(' ', '_')}.pdf',
        mimeType: 'application/pdf',
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 16),
                Text('PDF 다운로드가 완료되었습니다!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Download error: $e');
      if (mounted) {
        setState(() => _isDownloading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(child: Text('Download failed: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Parallax Background Layer
          Positioned.fill(
            child: FloatingDotsBackground(
              scrollController: _scrollController,
              isDark: isDark,
            ),
          ),

          // Content Layer
          Positioned.fill(
            child: projectsAsync.when(
              data: (projects) {
                final project = projects.firstWhere(
                  (p) => p.id == widget.projectId,
                  orElse: () => throw Exception('Project not found'),
                );

                  final title = project.title.toLowerCase();
                  final company = project.company.toLowerCase();
                  final isWallpad = (company.contains('hyundai ht') || company.contains('현대에이치티')) && (title.contains('wallpad') || title.contains('월패드'));
                  final isHtHome = (company.contains('hyundai ht') || company.contains('현대에이치티')) && (title.contains('home') || title.contains('홈'));
                  final isSoulark = title.contains('soulark') || title.contains('소울아크');
                  final isClosers = title.contains('closers') || title.contains('클로저스');
                  final isPromotion = title.contains('promotion') || title.contains('프로모션');
                  final isFarm = title.contains('farm') || title.contains('농가') || title.contains('농업');
                  final isAia = title.contains('aia') || company.contains('aia');
                  final isSamMes = title.contains('mes') || company.contains('코드브릿지') || company.contains('bridge');
                  final screenWidth = MediaQuery.of(context).size.width;

                  Widget imageWidget;
                  if (isWallpad) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> wallpadImages = [];
                    for (int i = 1; i <= 6; i++) {
                      wallpadImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/ht_01_slice_$i.jpg' : 'assets/images/ht_01_slice_$i.jpg',
                        'ratio': 2170 / 1920,
                      });
                    }
                    for (int i = 1; i <= 4; i++) {
                      wallpadImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/ht_02_1_slice_$i.jpg' : 'assets/images/ht_02_1_slice_$i.jpg',
                        'ratio': 2385 / 1920,
                      });
                    }
                    for (int i = 1; i <= 3; i++) {
                      wallpadImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/ht_02_2_slice_$i.jpg' : 'assets/images/ht_02_2_slice_$i.jpg',
                        'ratio': 2386 / 1920,
                      });
                    }
                    wallpadImages.add({
                      'url': isNetwork ? 'http://localhost:8080/images/ht_02_2_slice_4.jpg' : 'assets/images/ht_02_2_slice_4.jpg',
                      'ratio': 2383 / 1920,
                    });
                    for (int i = 1; i <= 3; i++) {
                      wallpadImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/ht_03_1_slice_$i.jpg' : 'assets/images/ht_03_1_slice_$i.jpg',
                        'ratio': 2448 / 1920,
                      });
                    }
                    wallpadImages.add({
                      'url': isNetwork ? 'http://localhost:8080/images/ht_03_1_slice_4.jpg' : 'assets/images/ht_03_1_slice_4.jpg',
                      'ratio': 2445 / 1920,
                    });
                    for (int i = 1; i <= 3; i++) {
                      wallpadImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/ht_03_2_slice_$i.jpg' : 'assets/images/ht_03_2_slice_$i.jpg',
                        'ratio': 2448 / 1920,
                      });
                    }
                    wallpadImages.add({
                      'url': isNetwork ? 'http://localhost:8080/images/ht_03_2_slice_4.jpg' : 'assets/images/ht_03_2_slice_4.jpg',
                      'ratio': 2446 / 1920,
                    });

                    imageWidget = Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: wallpadImages.map((imgData) {
                        final String imgUrl = imgData['url'] as String;
                        final double ratio = imgData['ratio'] as double;
                        final double calculatedHeight = screenWidth * ratio;

                        if (imgUrl.startsWith('http')) {
                          return WebOptimizedImage(
                            imageUrl: imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            loadingWidget: SizedBox(
                              height: calculatedHeight > 500 ? 500 : calculatedHeight,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else {
                          return Image.asset(
                            imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Asset not found: $imgUrl',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }).toList(),
                    );
                  } else if (isHtHome) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> htHomeImages = [];
                    for (int i = 1; i <= 3; i++) {
                      htHomeImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/hthome_01_1_slice_$i.jpg' : 'assets/images/hthome_01_1_slice_$i.jpg',
                        'ratio': 2475 / 1920,
                      });
                    }
                    htHomeImages.add({
                      'url': isNetwork ? 'http://localhost:8080/images/hthome_01_1_slice_4.jpg' : 'assets/images/hthome_01_1_slice_4.jpg',
                      'ratio': 2474 / 1920,
                    });
                    for (int i = 1; i <= 3; i++) {
                      htHomeImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/hthome_01_2_slice_$i.jpg' : 'assets/images/hthome_01_2_slice_$i.jpg',
                        'ratio': 2475 / 1920,
                      });
                    }
                    htHomeImages.add({
                      'url': isNetwork ? 'http://localhost:8080/images/hthome_01_2_slice_4.jpg' : 'assets/images/hthome_01_2_slice_4.jpg',
                      'ratio': 2474 / 1920,
                    });
                    for (int i = 1; i <= 4; i++) {
                      htHomeImages.add({
                        'url': isNetwork ? 'http://localhost:8080/images/hthome_01_3_slice_$i.jpg' : 'assets/images/hthome_01_3_slice_$i.jpg',
                        'ratio': 2475 / 1920,
                      });
                    }

                   imageWidget = Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: htHomeImages.map((imgData) {
                       final String imgUrl = imgData['url'] as String;
                       final double ratio = imgData['ratio'] as double;
                       final double calculatedHeight = screenWidth * ratio;

                       if (imgUrl.startsWith('http')) {
                         return WebOptimizedImage(
                           imageUrl: imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           loadingWidget: SizedBox(
                             height: calculatedHeight > 500 ? 500 : calculatedHeight,
                             child: const Center(child: CircularProgressIndicator()),
                           ),
                         );
                       } else {
                         return Image.asset(
                           imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           errorBuilder: (context, error, stackTrace) {
                             return SizedBox(
                               height: 300,
                               child: Center(
                                 child: Text(
                                   'Asset not found: $imgUrl',
                                   style: const TextStyle(color: Colors.white),
                                 ),
                               ),
                             );
                           },
                         );
                       }
                     }).toList(),
                   );
                 } else if (isSoulark) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> soularkImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/soulark_1.jpg' : 'assets/images/soulark_1.jpg',
                        'ratio': 7706 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/soulark_2.jpg' : 'assets/images/soulark_2.jpg',
                        'ratio': 7706 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/soulark_3.jpg' : 'assets/images/soulark_3.jpg',
                        'ratio': 7706 / 1920,
                      },
                    ];

                   imageWidget = Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: soularkImages.map((imgData) {
                       final String imgUrl = imgData['url'] as String;
                       final double ratio = imgData['ratio'] as double;
                       final double calculatedHeight = screenWidth * ratio;

                       if (imgUrl.startsWith('http')) {
                         return WebOptimizedImage(
                           imageUrl: imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           loadingWidget: SizedBox(
                             height: calculatedHeight > 500 ? 500 : calculatedHeight,
                             child: const Center(child: CircularProgressIndicator()),
                           ),
                         );
                       } else {
                         return Image.asset(
                           imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           errorBuilder: (context, error, stackTrace) {
                             return SizedBox(
                               height: 300,
                               child: Center(
                                 child: Text(
                                   'Asset not found: $imgUrl',
                                   style: const TextStyle(color: Colors.white),
                                 ),
                               ),
                             );
                           },
                         );
                       }
                     }).toList(),
                   );
                 } else if (isClosers) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> closersImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/closers_1.jpg' : 'assets/images/closers_1.jpg',
                        'ratio': 6652 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/closers_2.jpg' : 'assets/images/closers_2.jpg',
                        'ratio': 6652 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/closers_3.jpg' : 'assets/images/closers_3.jpg',
                        'ratio': 6654 / 1920,
                      },
                    ];

                   imageWidget = Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: closersImages.map((imgData) {
                       final String imgUrl = imgData['url'] as String;
                       final double ratio = imgData['ratio'] as double;
                       final double calculatedHeight = screenWidth * ratio;

                       if (imgUrl.startsWith('http')) {
                         return WebOptimizedImage(
                           imageUrl: imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           loadingWidget: SizedBox(
                             height: calculatedHeight > 500 ? 500 : calculatedHeight,
                             child: const Center(child: CircularProgressIndicator()),
                           ),
                         );
                       } else {
                         return Image.asset(
                           imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           errorBuilder: (context, error, stackTrace) {
                             return SizedBox(
                               height: 300,
                               child: Center(
                                 child: Text(
                                   'Asset not found: $imgUrl',
                                   style: const TextStyle(color: Colors.white),
                                 ),
                               ),
                             );
                           },
                         );
                       }
                     }).toList(),
                   );
                 } else if (isPromotion) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> promotionImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/promotion_1.jpg' : 'assets/images/promotion_1.jpg',
                        'ratio': 5993 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/promotion_2.jpg' : 'assets/images/promotion_2.jpg',
                        'ratio': 5994 / 1920,
                      },
                    ];

                   imageWidget = Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: promotionImages.map((imgData) {
                       final String imgUrl = imgData['url'] as String;
                       final double ratio = imgData['ratio'] as double;
                       final double calculatedHeight = screenWidth * ratio;

                       if (imgUrl.startsWith('http')) {
                         return WebOptimizedImage(
                           imageUrl: imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           loadingWidget: SizedBox(
                             height: calculatedHeight > 500 ? 500 : calculatedHeight,
                             child: const Center(child: CircularProgressIndicator()),
                           ),
                         );
                       } else {
                         return Image.asset(
                           imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           errorBuilder: (context, error, stackTrace) {
                             return SizedBox(
                               height: 300,
                               child: Center(
                                 child: Text(
                                   'Asset not found: $imgUrl',
                                   style: const TextStyle(color: Colors.white),
                                 ),
                               ),
                             );
                           },
                         );
                       }
                     }).toList(),
                   );
                 } else if (isFarm) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> farmImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/farm_1.jpg' : 'assets/images/farm_1.jpg',
                        'ratio': 6043 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/farm_2.jpg' : 'assets/images/farm_2.jpg',
                        'ratio': 6043 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/farm_3.jpg' : 'assets/images/farm_3.jpg',
                        'ratio': 6043 / 1920,
                      },
                    ];

                   imageWidget = Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: farmImages.map((imgData) {
                       final String imgUrl = imgData['url'] as String;
                       final double ratio = imgData['ratio'] as double;
                       final double calculatedHeight = screenWidth * ratio;

                       if (imgUrl.startsWith('http')) {
                         return WebOptimizedImage(
                           imageUrl: imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           loadingWidget: SizedBox(
                             height: calculatedHeight > 500 ? 500 : calculatedHeight,
                             child: const Center(child: CircularProgressIndicator()),
                           ),
                         );
                       } else {
                         return Image.asset(
                           imgUrl,
                           width: screenWidth,
                           height: calculatedHeight,
                           fit: BoxFit.fitWidth,
                           alignment: Alignment.topCenter,
                           errorBuilder: (context, error, stackTrace) {
                             return SizedBox(
                               height: 300,
                               child: Center(
                                 child: Text(
                                   'Asset not found: $imgUrl',
                                   style: const TextStyle(color: Colors.white),
                                 ),
                               ),
                             );
                           },
                         );
                       }
                     }).toList(),
                   );
                 } else if (isAia) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> aiaImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_1.jpg' : 'assets/images/aia_1.jpg',
                        'ratio': 2800 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_2.jpg' : 'assets/images/aia_2.jpg',
                        'ratio': 2800 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_3.jpg' : 'assets/images/aia_3.jpg',
                        'ratio': 2800 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_4.jpg' : 'assets/images/aia_4.jpg',
                        'ratio': 2800 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_5.jpg' : 'assets/images/aia_5.jpg',
                        'ratio': 2800 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/aia_6.jpg' : 'assets/images/aia_6.jpg',
                        'ratio': 2589 / 1920,
                      },
                    ];

                    imageWidget = Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: aiaImages.map((imgData) {
                        final String imgUrl = imgData['url'] as String;
                        final double ratio = imgData['ratio'] as double;
                        final double calculatedHeight = screenWidth * ratio;

                        if (imgUrl.startsWith('http')) {
                          return WebOptimizedImage(
                            imageUrl: imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            loadingWidget: SizedBox(
                              height: calculatedHeight > 500 ? 500 : calculatedHeight,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else {
                          return Image.asset(
                            imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Asset not found: $imgUrl',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }).toList(),
                    );
                  } else if (isSamMes) {
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> samImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_final.jpg' : 'assets/images/sam_mes_final.jpg',
                        'ratio': 22933 / 1920,
                      },
                    ];

                    imageWidget = Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: samImages.map((imgData) {
                        final String imgUrl = imgData['url'] as String;
                        final double ratio = imgData['ratio'] as double;
                        final double calculatedHeight = screenWidth * ratio;

                        if (imgUrl.startsWith('http')) {
                          return WebOptimizedImage(
                            imageUrl: imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            loadingWidget: SizedBox(
                              height: calculatedHeight > 500 ? 500 : calculatedHeight,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else {
                          return Image.asset(
                            imgUrl,
                            width: screenWidth,
                            height: calculatedHeight,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Asset not found: $imgUrl',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }).toList(),
                    );
                  } else if (project.imageUrl != null && project.imageUrl!.isNotEmpty) {
                    if (project.imageUrl!.startsWith('http')) {
                     // Use WebOptimizedImage for network images to bypass WebGL limits
                     imageWidget = WebOptimizedImage(
                       imageUrl: project.imageUrl!,
                       fit: BoxFit.fitWidth,
                       alignment: Alignment.topCenter,
                       loadingWidget: const SizedBox(
                         height: 300,
                         child: Center(child: CircularProgressIndicator()),
                       ),
                       errorWidget: const SizedBox(
                         height: 300,
                         child: Center(
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(
                                 Icons.broken_image,
                                 color: Colors.white,
                                 size: 48,
                               ),
                               SizedBox(height: 16),
                               Text(
                                 'Failed to load image',
                                 style: TextStyle(color: Colors.white),
                               ),
                             ],
                           ),
                         ),
                       ),
                     );
                   } else {
                     imageWidget = Image.asset(
                       project.imageUrl!,
                       fit: BoxFit.fitWidth,
                       alignment: Alignment.topCenter,
                       errorBuilder: (context, error, stackTrace) {
                         return SizedBox(
                           height: 300,
                           child: Center(
                             child: Text(
                               'Asset not found: ${project.imageUrl}',
                               style: const TextStyle(color: Colors.white),
                             ),
                           ),
                         );
                       },
                     );
                   }
                 } else {
                   imageWidget = const SizedBox(
                     height: 300,
                     child: Center(
                       child: Text(
                         'No image provided',
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                   );
                 }



                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        key: _imageKey,
                        width: double.infinity,
                        child: imageWidget,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // Overlay UI (Back Button & Download Button)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Download Button
                  projectsAsync.whenOrNull(
                        data: (projects) {
                          final project = projects.firstWhere(
                            (p) => p.id == widget.projectId,
                            orElse: () => projects.first,
                          );
                          if (project.imageUrl == null ||
                              !project.imageUrl!.startsWith('http')) {
                            return const SizedBox.shrink();
                          }
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isDownloading
                                  ? null
                                  : () => _downloadAsPdf(
                                      project.imageUrl!,
                                      project.title,
                                    ),
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.8,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: _isDownloading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          );
                        },
                      ) ??
                      const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // Scroll to Top Button
          Positioned(
            bottom: 30,
            right: 30,
            child: AnimatedOpacity(
              opacity: _showScrollButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                onPressed: _showScrollButton ? _scrollToTop : null,
                backgroundColor: AppColors.primaryBlue,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorTokenCard(Color color, String name, String token, String hex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      width: isMobile ? double.infinity : 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  token,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontFamily: 'monospace',
                    fontSize: 8,
                  ),
                ),
                Text(
                  hex,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDSHeader(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyRow(String label, String token, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            token,
            style: const TextStyle(color: Color(0xFF64748B), fontFamily: 'monospace', fontSize: 10),
          ),
          Text(
            detail,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineCard(
    String code,
    String status,
    String title,
    String client,
    String price,
    String sub,
    Color codeColor,
    Color statusColor,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      width: isMobile ? double.infinity : 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: codeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                child: Text(code, style: TextStyle(color: codeColor, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 11, fontWeight: FontWeight.bold)),
          Text(client, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: TextStyle(color: codeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

    Widget _buildSpecSection({
    required String title,
    required Widget mobilePreview,
    required List<String> mobileDos,
    required List<String> mobileDonts,
    required Widget desktopPreview,
    required List<String> desktopDos,
    required List<String> desktopDonts,
    required bool isDark,
    required bool isMobileLayout,
  }) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    Widget buildColumnContent({
      required String deviceLabel,
      required Widget preview,
      required List<String> dos,
      required List<String> donts,
    }) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  deviceLabel.contains('모바일') ? Icons.phone_android : Icons.desktop_windows,
                  size: 16,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),
                Text(
                  deviceLabel,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textMain),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(child: preview),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                const SizedBox(width: 6),
                Text('DO (권장 사항)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669))),
              ],
            ),
            const SizedBox(height: 6),
            ...dos.map((d) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)),
            )),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 14),
                const SizedBox(width: 6),
                Text("DON'T (금지 사항)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))),
              ],
            ),
            const SizedBox(height: 6),
            ...donts.map((d) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)),
            )),
          ],
        ),
      );
    }

    if (isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumnContent(
            deviceLabel: '모바일 (Mobile) 규격 명세',
            preview: mobilePreview,
            dos: mobileDos,
            donts: mobileDonts,
          ),
          const SizedBox(height: 20),
          buildColumnContent(
            deviceLabel: '태블릿 & 데스크톱 (Tablet & Desktop) 규격 명세',
            preview: desktopPreview,
            dos: desktopDos,
            donts: desktopDonts,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: buildColumnContent(
            deviceLabel: '모바일 (Mobile) 규격 명세',
            preview: mobilePreview,
            dos: mobileDos,
            donts: mobileDonts,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: buildColumnContent(
            deviceLabel: '태블릿 & 데스크톱 (Tablet & Desktop) 규격 명세',
            preview: desktopPreview,
            dos: desktopDos,
            donts: desktopDonts,
          ),
        ),
      ],
    );
  }

  Widget _buildDesignSystemSection({required bool isDark}) {
    const mesPrimaryBlue = Color(0xFF3B82F6);
    const mesSuccessGreen = Color(0xFF10B981);
    const mesWarningAmber = Color(0xFFF59E0B);
    const mesErrorRed = Color(0xFFEF4444);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final mesBgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      color: mesBgColor,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 60,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: mesPrimaryBlue.withOpacity(0.1),
                  border: Border.all(color: mesPrimaryBlue.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DESIGN SYSTEM SPEC',
                  style: TextStyle(
                    color: mesPrimaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '디자인시스템_최종',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: textMain,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SAM MES+ERP의 파운데이션, 이토믹 디자인 시스템, 대시보드 위젯을 모두 확인할 수 있습니다. 디자인 토큰 명명 규칙(Naming Rule)과 네이밍 명세(Spec)를 적용하여 대기업용 엔터프라이즈 환경에서 일관성 있고 확장 가능한 설계 프로세스를 수립했습니다.',
                style: TextStyle(
                  color: textSub,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('01. Foundation (기초 및 토큰 네이밍 룰)', '디자인 시스템의 기초 규격 및 디자인 토큰 체계'),
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: mesPrimaryBlue, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Design Token Naming Rule & Spec (디자인 토큰 명명 규칙 및 명세)',
                      style: TextStyle(color: textMain, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: textSub, fontSize: 13, height: 1.6, fontFamily: AppTypography.pretendard),
                        children: const [
                          TextSpan(
                            text: '명명 규칙 표준: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '--{category}-{type/use}-{scale/variant}\n',
                            style: TextStyle(fontFamily: 'monospace', color: mesPrimaryBlue, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Prefix', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': CSS 커스텀 속성 표준(--) 규격을 준수하여 웹 표준과 개발 호환성을 높임.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Category', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': color(색상), font(서체), space(여백), breakpoint(중단점)로 분류.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Type/Use', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': primary, semantic, functional, size, device 등의 세부 용도 기술.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Design Token Specification (토큰 명세)', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2.5),
                        2: FlexColumnWidth(1.8),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: borderColor, width: 0.5),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('카테고리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('토큰 패턴 (Token Pattern)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('사용 예시 (Example)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Color', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--color-{group}-{use}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('--color-primary-main', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: mesPrimaryBlue))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Typography', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--font-size-{size}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--font-size-h1 (24px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Spacing', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--spacing-{scale}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--spacing-lg (16px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Breakpoint', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--breakpoint-{device}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--breakpoint-tablet (768px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              Text('Color Tokens (라이트 / 다크모드 색상 명세)', style: TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(1.8),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: borderColor, width: 0.5),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('색상 분류', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('디자인 토큰명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Light Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Colors.transparent),
                    _buildColorTokenTableRow('Primary', '--color-primary-main', const Color(0xFF3B82F6), '#3B82F6', const Color(0xFF1E5EFF), '#1E5EFF', isDark),
                    _buildColorTokenTableRow('Primary FG', '--color-primary-fg', Colors.white, '#FFFFFF', Colors.white, '#FFFFFF', isDark),
                    _buildColorTokenTableRow('Success', '--color-success-main', const Color(0xFF10B981), '#10B981', const Color(0xFF059669), '#059669', isDark),
                    _buildColorTokenTableRow('Warning', '--color-warning-main', const Color(0xFFF59E0B), '#F59E0B', const Color(0xFFD97706), '#D97706', isDark),
                    _buildColorTokenTableRow('Error', '--color-error-main', const Color(0xFFEF4444), '#EF4444', const Color(0xFFDC2626), '#DC2626', isDark),
                    _buildColorTokenTableRow('Bg Primary', '--color-bg-primary', Colors.white, '#FFFFFF', const Color(0xFF0F172A), '#0F172A', isDark),
                    _buildColorTokenTableRow('Bg Secondary', '--color-bg-secondary', const Color(0xFFF8FAFC), '#F8FAFC', const Color(0xFF1E293B), '#1E293B', isDark),
                    _buildColorTokenTableRow('Text Primary', '--color-text-primary', const Color(0xFF1F2937), '#1F2937', const Color(0xFFF9FAFB), '#F9FAFB', isDark),
                    _buildColorTokenTableRow('Border Light', '--color-border-light', const Color(0xFFE2E8F0), '#E2E8F0', const Color(0xFF334155), '#334155', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;
                  final itemWidth = isWideScreen ? (constraints.maxWidth - 40) / 2 : double.infinity;

                  return Wrap(
                    spacing: 40,
                    runSpacing: 30,
                    children: [
                      Container(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Typography (Pretendard 명세)', style: TextStyle(color: textSub, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _buildTypographyRow('Heading 1', '--font-size-h1', '24px Bold'),
                            _buildTypographyRow('Heading 2', '--font-size-h2', '20px Bold'),
                            _buildTypographyRow('Heading 3', '--font-size-h3', '18px Bold'),
                            _buildTypographyRow('Paragraph', '--font-size-body', '14px Regular'),
                            _buildTypographyRow('Small Text', '--font-size-small', '12px Regular'),
                          ],
                        ),
                      ),
                      Container(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Spacing Scale (여백 토큰)', style: TextStyle(color: textSub, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.0),
                                1: FlexColumnWidth(2.0),
                                2: FlexColumnWidth(1.5),
                              },
                              border: TableBorder(
                                horizontalInside: BorderSide(color: borderColor, width: 0.5),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('크기', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('토큰 패턴 (Token Pattern)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('실물 크기 (Visual)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('xs (4px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-xs', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(4, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('sm (8px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-sm', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(8, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('md (12px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-md', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(12, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('lg (16px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-lg', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(16, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('xl (20px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-xl', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(20, '', isDark: isDark))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('02. Atoms (원자 컴포넌트)', '가장 기본적인 UI 빌딩 블록 (버튼, 뱃지, 입력 필드)'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Atoms',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mesPrimaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('모바일 버튼 (Full Width)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesPrimaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('기본', style: TextStyle(color: mesPrimaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('성공', style: TextStyle(color: mesSuccessGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesErrorRed.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('삭제', style: TextStyle(color: mesErrorRed, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
                mobileDos: const [
                  '모바일 버튼은 터치 정확도를 확보하기 위해 높이 48px 및 가로 채우기(Full Width) 배치를 사용하십시오.',
                  '가장 중요한 액션 1개만 강조 색상 버튼으로 제공하십시오.'
                ],
                mobileDonts: const [
                  '가로로 3개 이상의 버튼을 일렬 배치하지 마십시오 (줄 바꿈 또는 세로 정렬 권장).',
                  '작은 화면에서 폰트 크기를 12px 미만으로 낮추지 마십시오.'
                ],
                desktopPreview: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text('신규 등록', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mesPrimaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMain,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('취소', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                desktopDos: const [
                  '정밀 마우스 포인팅이 가능하므로 가로 간격(8px~12px)을 둔 인라인 배치를 적용하십시오.',
                  '기본 액션과 보조 액션(Cancel, Outline)을 명확히 구분하십시오.'
                ],
                desktopDonts: const [
                  '필요 이상으로 가로 길이를 넓혀 광활한 빈 공간을 만들지 마십시오.',
                  '단순 액션에 불필요하게 48px 이상의 대형 버튼을 남발하지 마십시오.'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('03. Molecules (분자 컴포넌트)', '기본 컴포넌트들을 조합한 단순 유닛 (드롭다운, 아코디언)'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Molecules',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('수주처 선택 (Bottom Sheet)', style: TextStyle(color: textMain, fontSize: 12)),
                      Icon(Icons.arrow_drop_down, size: 16, color: textSub),
                    ],
                  ),
                ),
                mobileDos: const [
                  '드롭다운 선택창 클릭 시 가독성 및 조작 용이성을 위해 하단 시트(Bottom Sheet) 모달 인터페이스를 제공하십시오.',
                  '옵션 텍스트는 1줄 이내로 표시하고 생략 기호(...)를 처리하십시오.'
                ],
                mobileDonts: const [
                  '모바일 뷰포트에서 마우스 호버 전용 드롭다운 메뉴를 설계하지 마십시오 (터치 호환 불가).',
                  '과도하게 긴 리스트를 모바일 인라인 팝오버로 띄우지 마십시오.'
                ],
                desktopPreview: Container(
                  width: 240,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('선택된 항목 표시', style: TextStyle(color: textMain, fontSize: 12)),
                      Icon(Icons.unfold_more, size: 16, color: textSub),
                    ],
                  ),
                ),
                desktopDos: const [
                  '마우스 스크롤이 가능한 인라인 팝오버 목록(Max Height: 250px)을 트리거 아래에 즉시 표시하십시오.',
                  '포커스 및 키보드 네비게이션(Arrow Keys) 접근성을 지원하십시오.'
                ],
                desktopDonts: const [
                  '드롭다운 선택 상자가 브라우저 경계선 바깥으로 잘려 나가지 않도록 오프셋 가이드라인을 준수하십시오.'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('04. Organisms (유기체 컴포넌트)', '원자/분자의 조합으로 구성된 완성도 높은 섹션 단위 및 업무용 카드'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Organisms',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Q-2024-001', style: TextStyle(color: textMain, fontSize: 11, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('승인', style: TextStyle(color: mesSuccessGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('서울 오피스텔 건설 프로젝트 수주 건', style: TextStyle(color: textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('삼성건설 | 25,600,000 원', style: TextStyle(color: textSub, fontSize: 10)),
                    ],
                  ),
                ),
                mobileDos: const [
                  '모바일 카드 컴포넌트는 모든 주요 정보를 수직 스택(Vertical Stack) 구조로 정렬하십시오.',
                  '상태 표시(Status Badge)는 카드 우측 상단에 정렬하여 빠르게 인지되도록 배포하십시오.'
                ],
                mobileDonts: const [
                  '가로 방향으로 다중 컬러칩이나 긴 문자열을 배치해 수평 스크롤이 발생하도록 만들지 마십시오.'
                ],
                desktopPreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Q-2024-001', style: TextStyle(color: textMain, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: const Text('승인', style: TextStyle(color: mesSuccessGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('서울 오피스텔 건설 프로젝트 수주 건', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('25,600,000 원', style: TextStyle(color: textMain, fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('삼성건설 (수주처)', style: TextStyle(color: textSub, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                desktopDos: const [
                  '가로 공간이 풍부하므로 정보 그룹(타이틀 정보 vs 메타 데이터 및 액션)을 양 끝단 배치(Space-Between)로 설계하여 스캔 가독성을 향상시키십시오.'
                ],
                desktopDonts: const [
                  '가로 폭이 넓어진다고 해서 모든 정보를 가로 한 줄에 빽빽하게 우겨넣지 마십시오 (필요한 컬럼만 명시적으로 구성).'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('05. Templates (템플릿 표준)', '기본 컴포넌트와 유기체가 결합된 업무 화면 레이아웃 정의'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Templates',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: mesPrimaryBlue.withOpacity(0.1),
                        child: const Center(child: Text('상단: 리스트 목록 (탭 전환/접기)', style: TextStyle(fontSize: 10, color: mesPrimaryBlue, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: mesSuccessGreen.withOpacity(0.1),
                        child: const Center(child: Text('하단: 상세 / 등록 양식 (단일화면 스택)', style: TextStyle(fontSize: 10, color: mesSuccessGreen, fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
                mobileDos: const [
                  '화면 높이 제한이 가로 제한보다 훨씬 크므로 목록형 보기와 상세 폼 보기를 탭(Tab) 또는 화면 단계 전환(Step Transition) 방식으로 단일 뷰 스택 배치를 구현하십시오.'
                ],
                mobileDonts: const [
                  '좌우 화면 분할Pane(Split layout)을 억지로 모바일에 삽입하여 양쪽 모두 오버플로우가 나게 하지 마십시오.'
                ],
                desktopPreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: mesPrimaryBlue.withOpacity(0.1),
                          child: const Center(child: Text('수주 목록 (좌측 Pane)', style: TextStyle(fontSize: 10, color: mesPrimaryBlue, fontWeight: FontWeight.bold))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: mesSuccessGreen.withOpacity(0.1),
                          child: const Center(child: Text('상세 내역 등록 및 정보 편집 (우측 Pane)', style: TextStyle(fontSize: 10, color: mesSuccessGreen, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                ),
                desktopDos: const [
                  '가로 화면을 100% 활용하기 위해 좌측 수주 목록-우측 상세(Split View, 4:6 비율) 표준을 적용하십시오.',
                  '가로 해상도가 축소될 때에도 유연한 반응형 Flex 비율을 유지하십시오.'
                ],
                desktopDonts: const [
                  '두 개 이상의 화면을 분할할 때 고정 너비(Width in px)를 지나치게 많이 지정해 가로 오버플로우가 나지 않도록 유의하십시오.'
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorTokenTableRow(String category, String token, Color lightColor, String lightHex, Color darkColor, String darkHex, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.8),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            children: [
              Text(category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textMain)),
              Text(token, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF64748B))),
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: lightColor,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(lightHex, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF475569))),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: darkColor,
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(darkHex, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAdminManagementSection({required bool isDark}) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final slateDark = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF1F2937);
    final slateLight = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final bgDark = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      width: double.infinity,
      color: bgDark,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ADMIN MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '시스템 관리자 - 디자인시스템 관리',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: slateDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '실제 운영 중인 SAM MES+ERP 시스템의 관리자 권한 전용 디자인시스템 관리자 화면입니다. 기초 토큰부터 컴포넌트, 디바이스별 반응형 중단점(Breakpoints)까지 실시간으로 커스텀하고 제어할 수 있는 어드민 콘솔 레이아웃을 확인하실 수 있습니다.',
                style: TextStyle(
                  color: textSub,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Mockup Window Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B0F19) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    // App Header
                    _buildAdminHeader(isDark),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 800;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isWide) _buildAdminSidebar(isDark),
                            Expanded(
                              child: _buildAdminWorkspace(isDark, isWide: isWide),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminHeader(bool isDark) {
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final logoColor = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgHeader = isDark ? const Color(0xFF111827) : Colors.white;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgHeader,
        border: Border(bottom: BorderSide(color: borderColor)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SAM',
                    style: TextStyle(
                      color: textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Smart Automation Management',
                    style: TextStyle(
                      color: textSub,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Center: Search Bar (Desktop only, or simplified)
          Container(
            width: 200,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 14, color: textSub),
                const SizedBox(width: 6),
                Text(
                  '통합 검색...',
                  style: TextStyle(color: textSub, fontSize: 10),
                ),
              ],
            ),
          ),
          // Right: Controls
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 16, color: textSub),
              const SizedBox(width: 14),
              Stack(
                children: [
                  Icon(Icons.notifications_none_outlined, size: 18, color: textSub),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              // Profile Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '최시스템',
                      style: TextStyle(color: textMain, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: logoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: logoColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '시스템관리자',
                  style: TextStyle(color: logoColor, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSidebar(bool isDark) {
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryBlue = const Color(0xFF1E5EFF);
    final bgSidebar = isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB);

    return Container(
      width: 220,
      height: 480,
      decoration: BoxDecoration(
        color: bgSidebar,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildSidebarItem(Icons.dashboard_outlined, '시스템 대시보드', false, isDark),
          _buildSidebarItem(Icons.people_outline, '사용자 관리', false, isDark),
          _buildSidebarItem(Icons.tune_outlined, '메뉴 커스터마이징', false, isDark),
          _buildSidebarItem(Icons.info_outline, '기준정보 관리', false, isDark, hasChevron: true),
          _buildSidebarItem(Icons.color_lens_outlined, '디자인시스템관리', true, isDark, hasChevron: true),
          // Submenus
          _buildSidebarSubItem('디자인시스템_최종', false, isDark),
          _buildSidebarSubItem('통합 디자인 시스템', false, isDark),
          _buildSidebarSubItem('디자인시스템 뷰어', false, isDark),
          _buildSidebarSubItem('컴포넌트 추출 도구', false, isDark),
          _buildSidebarSubItem('중앙 저장소', false, isDark),
          _buildSidebarSubItem('스타일 테스트', false, isDark),
          _buildSidebarSubItem('템플릿 비교', false, isDark),
          _buildSidebarSubItem('디자인시스템 관리', true, isDark),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive, bool isDark, {bool hasChevron = false}) {
    final activeBg = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isActive ? Colors.white : textSub),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : textMain,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (hasChevron)
            Icon(
              label == '디자인시스템관리' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? Colors.white : textSub,
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarSubItem(String label, bool isActive, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryBlue = const Color(0xFF1E5EFF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      padding: const EdgeInsets.only(left: 32, right: 12, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: isActive ? primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Small dot for submenus
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? primaryBlue : textSub.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? primaryBlue : textMain.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildAdminWorkspace(bool isDark, {required bool isWide}) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgWorkspace = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      height: 480,
      color: bgWorkspace,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '디자인시스템 관리',
                    style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Foundation, Components, Tokens, Responsive 관리',
                    style: TextStyle(color: textSub, fontSize: 9),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.restore_outlined, size: 10, color: textMain),
                    const SizedBox(width: 4),
                    Text(
                      '견적관리 컴포넌트 복구',
                      style: TextStyle(color: textMain, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 12, color: textSub),
                const SizedBox(width: 8),
                Text(
                  'Foundation, Components, Tokens, Responsive 통합 검색...',
                  style: TextStyle(color: textSub, fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildAdminTabItem('Foundation', Icons.layers_outlined, true, isDark),
                      _buildAdminTabItem('Components', Icons.widgets_outlined, false, isDark),
                      _buildAdminTabItem('Modules', Icons.view_module_outlined, false, isDark),
                      _buildAdminTabItem('Tokens', Icons.code_outlined, false, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAdminTabItem(String label, IconData icon, bool isActive, bool isDark) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? const Color(0xFF1E293B) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? Border.all(color: primaryBlue, width: 1.2) : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isActive ? primaryBlue : textSub),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryBlue : textMain,
              fontSize: 9,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointCard(String device, String widthDesc, String deviceDesc, IconData icon, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Device Name
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF1E5EFF)),
              const SizedBox(width: 6),
              Text(
                device,
                style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Dimensions description
          Text(
            widthDesc,
            style: TextStyle(color: textSub, fontSize: 8, height: 1.3),
          ),
          const SizedBox(height: 2),
          Text(
            deviceDesc,
            style: TextStyle(color: textSub.withValues(alpha: 0.7), fontSize: 8),
          ),
          const SizedBox(height: 12),
          // Edit/Delete Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildBreakpointCardAction(Icons.edit_outlined, '수정', isDark),
              const SizedBox(width: 4),
              _buildBreakpointCardAction(Icons.delete_outline, '삭제', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointCardAction(IconData icon, String label, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 8, color: textMain),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(color: textMain, fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingBox(double size, String label, {required bool isDark}) {
    return Column(
      children: [
        Container(
          width: size * 1.5,
          height: 12,
          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF0F172A), fontSize: 8),
        ),
      ],
    );
  }
}
