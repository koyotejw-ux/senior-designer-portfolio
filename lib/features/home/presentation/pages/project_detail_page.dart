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
                    final isNetwork = project.imageUrl != null && project.imageUrl!.startsWith('http');
                    final List<Map<String, dynamic>> samMesImages = [
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_1.jpg' : 'assets/images/sam_mes_1.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_2.jpg' : 'assets/images/sam_mes_2.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_3.jpg' : 'assets/images/sam_mes_3.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_4.jpg' : 'assets/images/sam_mes_4.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_5.jpg' : 'assets/images/sam_mes_5.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_6.jpg' : 'assets/images/sam_mes_6.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_7.jpg' : 'assets/images/sam_mes_7.jpg',
                        'ratio': 2866 / 1920,
                      },
                      {
                        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_8.jpg' : 'assets/images/sam_mes_8.jpg',
                        'ratio': 2871 / 1920,
                      },
                    ];

                    imageWidget = Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: samMesImages.map((imgData) {
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
                  physics: const ClampingScrollPhysics(), // Prevent overscroll
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Prevent extra scrolling
                    children: [
                      // The Main Image - Full Width (Fit Width)
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
}
