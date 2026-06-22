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
                        // Admin Management UI Section
                        _buildAdminManagementSection(isDark: isDark),
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

  Widget _buildColorTokenCard(Color color, String name, String token, String hex) {
    return Container(
      width: 250,
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
    return Container(
      width: 250,
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
    Widget _buildDesignSystemSection({required bool isDark}) {
    const mesPrimaryBlue = Color(0xFF3B82F6);
    const mesSuccessGreen = Color(0xFF10B981);
    const mesWarningAmber = Color(0xFFF59E0B);
    const mesErrorRed = Color(0xFFEF4444);

    const mesSlateDark = Color(0xFF1F2937);
    const mesBorderColor = Color(0xFFE2E8F0);
    const mesBgColor = Colors.white;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
              // Section Badge
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
              const Text(
                '디자인시스템_최종',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SAM MES+ERP의 파운데이션, 이토믹 디자인 시스템, 대시보드 위젯을 모두 확인할 수 있습니다. 디자인 토큰 명명 규칙(Naming Rule)을 정립하여 대기업용 엔터프라이즈 환경에서 일관성 있고 확장 가능한 설계 프로세스를 수립했습니다.',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 30),

              // 1. Foundation & Token Naming Rule
              _buildDSHeader('01. Foundation (기초 및 토큰 네이밍 룰)', '디자인 시스템의 기초 규격 및 디자인 토큰 체계'),
              const SizedBox(height: 24),
              
              // Naming Rule Block - Clean document design with left accent line
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
                    const Text(
                      'Design Token Naming Rule (디자인 토큰 명명 규칙)',
                      style: TextStyle(color: Color(0xFF1F2937), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.6, fontFamily: AppTypography.pretendard),
                        children: [
                          TextSpan(
                            text: '규칙 표준: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '--{category}-{type/use}-{scale/variant}\n',
                            style: TextStyle(fontFamily: 'monospace', color: mesPrimaryBlue, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Prefix', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': W3C Design Tokens 표준 규격 및 CSS 커스텀 속성 표준(--)을 준수합니다.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Category', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': color(색상), typography(서체), spacing(여백), border(테두리), shadow(그림자) 등 시각적 속성으로 분류.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Type/Use', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': primary, success, warning, error, info, background, text 등 구체적 용도를 명시.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Scale/Variant', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': main, hover, active, light, dark 또는 100~900 단위 수치로 확장성 부여.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Color Tokens Grouped
              const Text('Color Tokens', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // Primary Group
              const Text('Primary', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildColorTokenCard(mesPrimaryBlue, 'Primary', '--primary', '#3B82F6'),
                  _buildColorTokenCard(Colors.white, 'Primary Foreground', '--primary-foreground', '#FFFFFF'),
                ],
              ),
              const SizedBox(height: 24),
              
              // Semantic Group
              const Text('Semantic', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildColorTokenCard(mesSuccessGreen, 'Success', '--success-color', '#10B981'),
                  _buildColorTokenCard(mesWarningAmber, 'Warning', '--warning-color', '#F59E0B'),
                  _buildColorTokenCard(mesErrorRed, 'Error', '--error-color', '#EF4444'),
                  _buildColorTokenCard(mesPrimaryBlue, 'Info', '--info-color', '#3B82F6'),
                ],
              ),
              const SizedBox(height: 24),

              // Functional Group
              const Text('Functional', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildColorTokenCard(Colors.white, 'Background Primary', '--background-color', '#FFFFFF'),
                  _buildColorTokenCard(const Color(0xFFF8FAFC), 'Background Secondary', '--background-secondary-color', '#F8FAFC'),
                  _buildColorTokenCard(const Color(0xFF1F2937), 'Text Primary', '--text-primary-color', '#1F2937'),
                  _buildColorTokenCard(const Color(0xFFE2E8F0), 'Border Light', '--border-color', '#E2E8F0'),
                ],
              ),
              const SizedBox(height: 40),

              // Typography & Spacing
              const Text('Typography & Spacing Scale', style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 40,
                runSpacing: 30,
                children: [
                  // Typography Card (Spacious Table Format)
                  Container(
                    width: isMobile ? double.infinity : 550,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Typography (Pretendard 명세)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildTypographyRow('Heading 1', '--font-size-h1', '24px Bold'),
                        _buildTypographyRow('Heading 2', '--font-size-h2', '20px Bold'),
                        _buildTypographyRow('Heading 3', '--font-size-h3', '18px Bold'),
                        _buildTypographyRow('Paragraph', '--font-size-body', '14px Regular'),
                        _buildTypographyRow('Small Text', '--font-size-small', '12px Regular'),
                      ],
                    ),
                  ),
                  // Spacing Card
                  Container(
                    width: isMobile ? double.infinity : 550,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Spacing Scale (여백 토큰)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _buildSpacingBox(4, 'xs (4px)', isDark: isDark),
                            _buildSpacingBox(8, 'sm (8px)', isDark: isDark),
                            _buildSpacingBox(12, 'md (12px)', isDark: isDark),
                            _buildSpacingBox(16, 'lg (16px)', isDark: isDark),
                            _buildSpacingBox(20, 'xl (20px)', isDark: isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 30),

              // 2. Atoms (Open Layout, No wrapping grey card)
              _buildDSHeader('02. Atoms (원자)', '가장 기본적인 UI 빌딩 블록 (버튼, 뱃지, 입력 필드 등)'),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Button & Badge', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildActionBtn(Icons.check, '기본', mesPrimaryBlue, Colors.white, borderColor: mesPrimaryBlue),
                      _buildActionBtn(Icons.close, 'Outline', Colors.white, mesSlateDark, borderColor: const Color(0xFFE2E8F0)),
                      _buildActionBtn(Icons.delete_outline, 'Destructive', mesErrorRed, Colors.white, borderColor: mesErrorRed),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: mesPrimaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('기본 뱃지', style: TextStyle(color: mesPrimaryBlue, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('성공 뱃지', style: TextStyle(color: mesSuccessGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: mesErrorRed.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('삭제 뱃지', style: TextStyle(color: mesErrorRed, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Input Fields & Separator', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    maxConstraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      border: Border.all(color: const Color(0xFFE2E8F0)), 
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: const Text('이름을 입력하세요 (Input Field)', style: TextStyle(color: Colors.black38, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFE2E8F0)),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 30),

              // 3. Molecules (Open Layout)
              _buildDSHeader('03. Molecules (분자)', '원자 컴포넌트들의 결합으로 구성된 단위 컴포넌트'),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select (드롭다운)', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    maxConstraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('옵션을 선택하세요 (활성 상태)', style: TextStyle(color: mesSlateDark, fontSize: 12)),
                        Icon(Icons.arrow_drop_down, size: 18, color: mesSlateDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Accordion (접고 펼치기)', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    maxConstraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      border: Border.all(color: const Color(0xFFE2E8F0)), 
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('기본 정보 (Accordion Title)', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_up, size: 18, color: mesSlateDark),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('회사명: SAM 시스템\n업종: 제조업\n설립일: 2024-01-01', style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.6)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 30),

              // 4. Organisms (Open Layout, incorporating Cards)
              _buildDSHeader('04. Organisms (유기체 및 카드)', '분자 컴포넌트와 원자들이 결합하여 구성하는 실물 화면 단위 및 카드 컴포넌트'),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Page Header & Stat Cards', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      border: Border.all(color: const Color(0xFFE2E8F0)), 
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('수주 관리 대시보드', style: TextStyle(color: mesSlateDark, fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('실시간 주문 현황판', style: TextStyle(color: Colors.black45, fontSize: 10)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: mesPrimaryBlue, borderRadius: BorderRadius.circular(4)),
                          child: const Text('신규 주문 등록', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Business Cards Preview (실물 카드 컴포넌트)', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      // Quote Card
                      _buildInlineCard('Q-2024-001', '승인', '서울 오피스텔 프로젝트', '삼성건설', '25,600,000 원', '유효기한: 2024-02-15', mesPrimaryBlue, mesSuccessGreen),
                      // Sales Order Card
                      _buildInlineCard('SO-2024-001', '생산중', '부산 아파트 프로젝트', '현대건설', '48,000,000 원', '출하 진행률: 60%', Colors.purple, mesPrimaryBlue),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 30),

              // 5. Templates (Open Layout)
              _buildDSHeader('05. Templates (템플릿)', '업무 화면의 레이아웃 배치 표준 정의'),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unified List & Form Template Layout', style: TextStyle(color: mesSlateDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      Container(
                        width: isMobile ? double.infinity : 280,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('List Template', style: TextStyle(color: mesPrimaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(height: 10, color: const Color(0xFFF1F5F9)),
                            const SizedBox(height: 6),
                            Container(height: 20, color: const Color(0xFFF1F5F9)),
                          ],
                        ),
                      ),
                      Container(
                        width: isMobile ? double.infinity : 280,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Form Template', style: TextStyle(color: mesSuccessGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: Container(height: 20, color: const Color(0xFFF1F5F9))),
                                const SizedBox(width: 6),
                                Expanded(child: Container(height: 20, color: const Color(0xFFF1F5F9))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
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

  Widget _buildSmallTab(String label, bool isSelected, {required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E5EFF) : (isDark ? const Color(0xFF1E293B) : Colors.white),
        border: Border.all(color: isSelected ? const Color(0xFF1E5EFF) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
          fontSize: 8,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color bgColor, Color textColor, {required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
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
          // Top Nav Path
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
              // Recovery Button
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
          // Search box
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
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildAdminTabItem('Foundation', Icons.layers_outlined, false, isDark),
                      _buildAdminTabItem('Components', Icons.widgets_outlined, false, isDark),
                      _buildAdminTabItem('Modules', Icons.view_module_outlined, false, isDark),
                      _buildAdminTabItem('Tokens', Icons.code_outlined, false, isDark),
                      _buildAdminTabItem('Responsive', Icons.devices_outlined, true, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Breakpoints Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '브레이크포인트 (Breakpoints)',
                style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 11),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 10, color: Colors.white),
                    const SizedBox(width: 4),
                    const Text(
                      '브레이크포인트 추가',
                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Breakpoints list (Mobile, Tablet, Desktop)
          isWide
              ? Row(
                  children: [
                    Expanded(child: _buildBreakpointCard('Mobile', '최소 너비: 0px\n최대 너비: 767px', '모바일 디바이스', Icons.phone_android_outlined, isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBreakpointCard('Tablet', '최소 너비: 768px\n최대 너비: 1023px', '태블릿 디바이스', Icons.tablet_mac_outlined, isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBreakpointCard('Desktop', '최소 너비: 1024px', '데스크톱 디바이스', Icons.desktop_windows_outlined, isDark)),
                  ],
                )
              : Column(
                  children: [
                    _buildBreakpointCard('Mobile', '최소 너비: 0px\n최대 너비: 767px', '모바일 디바이스', Icons.phone_android_outlined, isDark),
                    const SizedBox(height: 8),
                    _buildBreakpointCard('Tablet', '최소 너비: 768px\n최대 너비: 1023px', '태블릿 디바이스', Icons.tablet_mac_outlined, isDark),
                    const SizedBox(height: 8),
                    _buildBreakpointCard('Desktop', '최소 너비: 1024px', '데스크톱 디바이스', Icons.desktop_windows_outlined, isDark),
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
}
