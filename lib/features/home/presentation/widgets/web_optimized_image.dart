import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

/// Web-optimized image widget that bypasses WebGL texture size limits
/// by using native HTML img elements via platform views
class WebOptimizedImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final Alignment alignment;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? width;
  final double? height;

  const WebOptimizedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.loadingWidget,
    this.errorWidget,
    this.width,
    this.height,
  });

  @override
  State<WebOptimizedImage> createState() => _WebOptimizedImageState();
}

class _WebOptimizedImageState extends State<WebOptimizedImage> {
  late String viewId;
  static int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Create unique view ID
    viewId = 'web-image-${_counter++}-${widget.imageUrl.hashCode}';
    _registerImageView();
  }

  void _registerImageView() {
    // Determine the actual image URL, supporting relative assets with base-href prefixing
    String finalUrl = widget.imageUrl;
    if (finalUrl.startsWith('assets/')) {
      // For GitHub Pages or standard subfolder deploys, we should resolve relative assets properly
      final baseElement = html.document.getElementsByTagName('base').firstOrNull;
      final baseHref = baseElement != null && baseElement is html.HtmlElement ? baseElement.getAttribute('href') ?? '/' : '/';
      finalUrl = baseHref + finalUrl;
      // Clean duplicate slashes
      if (finalUrl.startsWith('/')) {
        finalUrl = finalUrl.substring(1);
      }
      finalUrl = 'senior-designer-portfolio/' + finalUrl;
      finalUrl = '/' + finalUrl;
    }

    // Register a platform view factory for this image
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final img = html.ImageElement()
          ..src = finalUrl
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..style.objectFit = _getObjectFit(widget.fit)
          ..style.objectPosition = _getObjectPosition(widget.alignment);

        return img;
      },
    );
  }

  String _getObjectFit(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitWidth:
        return 'cover';
      case BoxFit.fitHeight:
        return 'cover';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
    }
  }

  String _getObjectPosition(Alignment alignment) {
    final x = ((alignment.x + 1) / 2 * 100).toStringAsFixed(0);
    final y = ((alignment.y + 1) / 2 * 100).toStringAsFixed(0);
    return '$x% $y%';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(
        viewType: viewId,
      ),
    );
  }
}
