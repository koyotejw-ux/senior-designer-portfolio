import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
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
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = '${projectTitle.replaceAll(' ', '_')}.pdf'
        ..click();

      html.Url.revokeObjectUrl(url);

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
                    // SAM MES uses split layout: images 1-6, design system, images 7-8
                    imageWidget = const SizedBox.shrink();
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

                if (isSamMes) {
                  final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                  final samMesPart1 = <Map<String, dynamic>>[
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_1.jpg' : 'assets/images/sam_mes_1.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_2.jpg' : 'assets/images/sam_mes_2.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_3.jpg' : 'assets/images/sam_mes_3.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_4.jpg' : 'assets/images/sam_mes_4.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_5.jpg' : 'assets/images/sam_mes_5.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_6.jpg' : 'assets/images/sam_mes_6.jpg', 'ratio': 2866 / 1920},
                  ];
                  final samMesPart2 = <Map<String, dynamic>>[
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_7.jpg' : 'assets/images/sam_mes_7.jpg', 'ratio': 2866 / 1920},
                    {'url': isNetwork ? 'http://localhost:8080/images/sam_mes_8.jpg' : 'assets/images/sam_mes_8.jpg', 'ratio': 2871 / 1920},
                  ];

                  Widget buildSamMesImageColumn(List<Map<String, dynamic>> images) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: images.map((imgData) {
                        final String imgUrl = imgData['url'] as String;
                        final double ratio = imgData['ratio'] as double;
                        final double h = screenWidth * ratio;
                        if (imgUrl.startsWith('http')) {
                          return WebOptimizedImage(
                            imageUrl: imgUrl, width: screenWidth, height: h,
                            fit: BoxFit.fitWidth, alignment: Alignment.topCenter,
                            loadingWidget: SizedBox(height: h > 500 ? 500 : h, child: const Center(child: CircularProgressIndicator())),
                          );
                        } else {
                          return Image.asset(imgUrl, width: screenWidth, height: h, fit: BoxFit.fitWidth, alignment: Alignment.topCenter,
                            errorBuilder: (c, e, s) => SizedBox(height: 300, child: Center(child: Text('Asset not found: $imgUrl', style: const TextStyle(color: Colors.white)))),
                          );
                        }
                      }).toList(),
                    );
                  }

                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Part 1: Images 1-6
                        SizedBox(
                          key: _imageKey,
                          width: double.infinity,
                          child: buildSamMesImageColumn(samMesPart1),
                        ),
                        // Design System Specification Section
                        _buildDesignSystemSection(isDark: isDark),
                        // Part 2: Images 7-8 (UI Screens)
                        SizedBox(
                          width: double.infinity,
                          child: buildSamMesImageColumn(samMesPart2),
                        ),
                      ],
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

  Widget _buildDesignSystemSection({required bool isDark}) {
    // Light-theme colors from original React project (DesignSystemFinal.tsx)
    const mesPrimaryBlue = Color(0xFF3B82F6);
    const mesSuccessGreen = Color(0xFF10B981);
    const mesWarningAmber = Color(0xFFF59E0B);
    const mesErrorRed = Color(0xFFEF4444);
    const mesSlateDark = Color(0xFF1A1A1A);
    const mesSlateLight = Color(0xFFF8FAFC);
    const mesBorderColor = Color(0xFFE2E8F0);

    final categories = [
      {
        'title': '01. Foundation (기초)',
        'icon': Icons.layers_outlined,
        'desc': '디자인 토큰 및 기본 스타일 (컬러, 타이포, 스페이싱, 섀도우)',
        'tags': ['Color Tokens', 'Typography', 'Spacing Tokens', 'Shadow Tokens'],
        'color': mesPrimaryBlue,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. Color Tokens', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Primary & Semantic', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildColorChip(mesPrimaryBlue, 'Primary', '--primary', mesSlateDark),
                _buildColorChip(mesSuccessGreen, 'Success', '--success-color', mesSlateDark),
                _buildColorChip(mesWarningAmber, 'Warning', '--warning-color', mesSlateDark),
                _buildColorChip(mesErrorRed, 'Error', '--error-color', mesSlateDark),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Functional & Neutral', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildColorChip(const Color(0xFF65A30D), 'Quote', '--quote-color', mesSlateDark),
                _buildColorChip(const Color(0xFF2563EB), 'Calculation', '--calculation-color', mesSlateDark),
                _buildColorChip(const Color(0xFF9333EA), 'Order', '--order-color', mesSlateDark),
                _buildColorChip(mesSlateDark, 'Foreground', '--foreground', mesSlateDark),
              ],
            ),
            const SizedBox(height: 14),
            const Text('2. Typography (Pretendard 서체 체계)', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('H1 - 2xl (대시보드)', style: TextStyle(fontFamily: AppTypography.pretendard, fontWeight: FontWeight.w600, color: mesSlateDark, fontSize: 14)),
            Text('H2 - xl (섹션 제목)', style: TextStyle(fontFamily: AppTypography.pretendard, fontWeight: FontWeight.w600, color: mesSlateDark, fontSize: 12)),
            Text('H3 - lg (카드 제목)', style: TextStyle(fontFamily: AppTypography.pretendard, fontWeight: FontWeight.w600, color: mesSlateDark, fontSize: 11)),
            Text('Body - base (본문 텍스트)', style: TextStyle(fontFamily: AppTypography.pretendard, fontWeight: FontWeight.normal, color: mesSlateDark.withValues(alpha: 0.7), fontSize: 10)),
            const SizedBox(height: 14),
            const Text('3. Spacing Tokens', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildSpacingBox(4, 'xs (4px)'),
                _buildSpacingBox(8, 'sm (8px)'),
                _buildSpacingBox(16, 'md (16px)'),
                _buildSpacingBox(24, 'lg (24px)'),
              ],
            ),
            const SizedBox(height: 14),
            const Text('4. Shadow Tokens', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildShadowPreview('clean-shadow-sm', '0 1px 2px rgba(0, 0, 0, 0.05)'),
                const SizedBox(width: 8),
                _buildShadowPreview('clean-shadow', '0 1px 3px rgba(0, 0, 0, 0.1)'),
              ],
            ),
          ],
        ),
      },
      {
        'title': '02. Atoms (원자)',
        'icon': Icons.auto_awesome_mosaic_outlined,
        'desc': '가장 작은 단위의 컴포넌트',
        'tags': ['BadgeSm', 'StatusBadge', 'TabChip', 'DateDisplay'],
        'color': mesPrimaryBlue,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Atoms 컴포넌트 실물', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // 1. BadgeSm
            const Text('BadgeSm', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: mesPrimaryBlue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2)),
                  child: const Text('수주전환', style: TextStyle(color: mesPrimaryBlue, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: mesSuccessGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2)),
                  child: const Text('최종확정', style: TextStyle(color: mesSuccessGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 2. StatusBadge
            const Text('StatusBadge', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                  child: const Text('초기작성 (견적)', style: TextStyle(color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                  child: const Text('수주확정 (수주)', style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 3. TabChip
            const Text('TabChip', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildSmallTab('전체', true),
                _buildSmallTab('완료', false),
              ],
            ),
            const SizedBox(height: 8),
            // 4. DateDisplay
            const Text('DateDisplay', style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 10, color: Color(0xFF64748B)),
                SizedBox(width: 4),
                Text('2025-01-15', style: TextStyle(color: mesSlateDark, fontSize: 9)),
              ],
            ),
          ],
        ),
      },
      {
        'title': '03. Molecules (분자)',
        'icon': Icons.grid_view_outlined,
        'desc': 'Atoms의 조합으로 만든 컴포넌트 (13개)',
        'tags': ['StatCard', 'SearchBar', 'ActionButtonGroup', 'FormField', 'SelectField', 'TextareaField', 'InfoRow', 'StandardDialog', 'AddressSearch', 'FormulaHelper', 'MultiStageSelector', 'TabNavigationMolecule', 'ValidationErrorSummary'],
        'color': mesSuccessGreen,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Molecules 주요 실물 샘플', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // 1. StatCard
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(6)),
              child: const Row(
                children: [
                  Icon(Icons.file_copy, color: Colors.blue, size: 14),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('총 견적', style: TextStyle(color: Color(0xFF64748B), fontSize: 7)),
                      Text('156 건', style: TextStyle(color: mesSlateDark, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 2. SearchBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(4)),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black38, size: 12),
                  SizedBox(width: 6),
                  Text('견적번호, 거래처명으로 검색...', style: TextStyle(color: Colors.black38, fontSize: 9)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 3. ActionButtonGroup
            Row(
              children: [
                _buildActionBtn(Icons.add, '신규', mesPrimaryBlue, Colors.white),
                const SizedBox(width: 4),
                _buildActionBtn(Icons.download, '내보내기', Colors.white, mesSlateDark),
              ],
            ),
            const SizedBox(height: 8),
            // 4. FormField / SelectField
            const Text('품목명', style: TextStyle(color: mesSlateDark, fontSize: 8, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(4)),
              child: const Row(
                children: [
                  Text('자동차 실린더 블록 H3', style: TextStyle(color: mesSlateDark, fontSize: 8)),
                ],
              ),
            ),
          ],
        ),
      },
      {
        'title': '04. Organisms (유기체)',
        'icon': Icons.dashboard_customize_outlined,
        'desc': 'Molecules의 조합으로 만든 복잡한 컴포넌트 (10개)',
        'tags': ['PageHeader', 'CommonDataTable', 'SearchFilter', 'FormSection', 'DetailSection', 'ListActions', 'PageLayout', 'StatCards', 'EmptyState', 'MobileCard'],
        'color': mesWarningAmber,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Organisms 주요 실물 샘플', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // 1. PageHeader
            Container(
              padding: const EdgeInsets.all(6),
              color: mesSlateLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SAM MES+ERP', style: TextStyle(color: Colors.black45, fontSize: 6)),
                      Text('디자인시스템_최종', style: TextStyle(color: mesSlateDark, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    color: mesPrimaryBlue,
                    child: const Text('등록', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 2. CommonDataTable
            Container(
              decoration: BoxDecoration(border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(4)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: mesSlateLight,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('코드', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: mesSlateDark)),
                        Text('상태', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: mesSlateDark)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: Colors.white,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SO-2026', style: TextStyle(fontSize: 7, color: mesSlateDark)),
                        Text('최종확정', style: TextStyle(fontSize: 7, color: mesSuccessGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      },
      {
        'title': '05. Dashboard Widgets (대시보드 위젯)',
        'icon': Icons.grid_view,
        'desc': '대시보드에서 사용하는 업무 맞춤형 위젯 (22개)',
        'tags': ['QuickActions', 'SalesOverview', 'SalesTrend', 'SalesAchievement', 'DailySummary', 'DailyQuote', 'ProductionStatus', 'ProcessOverview', 'InventoryStatus', 'QualityStatus', 'ShippingStatus', 'PurchaseStatus', 'ScheduleCalendar', 'TopCustomers', 'Receivables', 'ReceivablesTrend', 'CashFlow', 'ApprovalStatus', 'Notifications', 'HRStatus', 'VehicleStatus', 'CustomerCredit'],
        'color': Colors.purple,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('대시보드 핵심 위젯 2종 실물 예시', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Widget 1: QuickActions (빠른 작업)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QuickActions (빠른 작업)', style: TextStyle(color: mesSlateDark, fontSize: 8, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickActionItem(Icons.description, '견적 작성'),
                      _buildQuickActionItem(Icons.shopping_cart, '수주 등록'),
                      _buildQuickActionItem(Icons.print, '인쇄'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Widget 2: SalesOverview (영업 현황)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor), borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SalesOverview (영업 현황)', style: TextStyle(color: mesSlateDark, fontSize: 8, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('목표 달성률 85%', style: TextStyle(fontSize: 7, color: Color(0xFF64748B))),
                      Text('₩124,000,000', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: mesPrimaryBlue)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      },
      {
        'title': '06. Templates (템플릿)',
        'icon': Icons.splitscreen_outlined,
        'desc': '기본 레이아웃 및 뷰 표준 구조 정의 (4개)',
        'tags': ['IntegratedListTemplateV2', 'DetailViewTemplateV3', 'CreateFormTemplate', 'ResponsiveListTemplate'],
        'color': Colors.pink,
        'preview': Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Templates 3종 구조 모식도', style: TextStyle(color: mesSlateDark, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // 1. IntegratedListTemplateV2
            const Text('IntegratedListTemplateV2 (견적/수주/품목 목록)', style: TextStyle(color: Colors.black54, fontSize: 7, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(color: mesSlateLight, border: Border.all(color: mesBorderColor)),
                    child: const Center(child: Text('Sidebar', style: TextStyle(fontSize: 5))),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor)),
                    child: const Center(child: Text('List Grid Workspace', style: TextStyle(fontSize: 5))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 2. DetailViewTemplateV3 (3컬럼 그리드)
            const Text('DetailViewTemplateV3 (3컬럼 상세 정보)', style: TextStyle(color: Colors.black54, fontSize: 7, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(child: Container(height: 16, color: mesSlateLight, child: const Center(child: Text('기본정보', style: TextStyle(fontSize: 4))))),
                const SizedBox(width: 2),
                Expanded(child: Container(height: 16, color: mesSlateLight, child: const Center(child: Text('상세내역', style: TextStyle(fontSize: 4))))),
                const SizedBox(width: 2),
                Expanded(child: Container(height: 16, color: mesSlateLight, child: const Center(child: Text('히스토리', style: TextStyle(fontSize: 4))))),
              ],
            ),
            const SizedBox(height: 6),
            // 3. CreateFormTemplate (등록 폼)
            const Text('CreateFormTemplate (입력 폼)', style: TextStyle(color: Colors.black54, fontSize: 7, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: mesBorderColor)),
              child: Row(
                children: [
                  Expanded(child: Container(height: 10, color: mesSlateLight)),
                  const SizedBox(width: 4),
                  Expanded(child: Container(height: 10, color: mesSlateLight)),
                ],
              ),
            ),
          ],
        ),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      color: Colors.white, // 전체 이미지에 맞게 배경 화이트로 설정
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
              // Section Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: mesPrimaryBlue.withValues(alpha: 0.1),
                  border: Border.all(color: mesPrimaryBlue.withValues(alpha: 0.3)),
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
                '디자인시스템',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: mesSlateDark,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 28 : 38,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SAM MES+ERP 솔루션의 고품질 일관성을 보장하기 위해 도입된 디자인 시스템 구성 요소입니다. React 컴포넌트 라이브러리 및 공통 스타일 명세를 구조화하여 대기업용 시스템 완성도를 확보했습니다.',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Grid of Design System Tiers
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: categories.map((cat) {
                  final catColor = cat['color'] as Color;
                  final double cardWidth = isMobile
                      ? screenWidth - 48.0
                      : (screenWidth > 1200 ? 564.0 : (screenWidth - 144.0) / 2);
                  return Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: mesBorderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + Title
                        Row(
                          children: [
                            Icon(cat['icon'] as IconData, color: catColor, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cat['title'] as String,
                                style: const TextStyle(
                                  color: mesSlateDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['desc'] as String,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Real UI Preview Panel
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: mesSlateLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: mesBorderColor,
                            ),
                          ),
                          child: cat['preview'] as Widget,
                        ),
                        const SizedBox(height: 20),
                        // Component Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (cat['tags'] as List<String>).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.1),
                                border: Border.all(color: catColor.withValues(alpha: 0.2), width: 0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: catColor.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorChip(Color color, String name, String hex, Color textColor) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.bold),
        ),
        Text(
          hex,
          style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 7),
        ),
      ],
    );
  }

  Widget _buildSpacingBox(double size, String label) {
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
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildShadowPreview(String name, String shadowValue) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E5EFF) : Colors.white,
        border: Border.all(color: isSelected ? const Color(0xFF1E5EFF) : const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF0F172A),
          fontSize: 8,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 10),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.description, color: Color(0xFF3B82F6), size: 12),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 7)),
      ],
    );
  }
}
