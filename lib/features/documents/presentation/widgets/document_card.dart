import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/document_model.dart';

class DocumentCard extends ConsumerStatefulWidget {
  final DocumentModel document;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
  });

  @override
  ConsumerState<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends ConsumerState<DocumentCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevationAnimation = Tween<double>(begin: 4.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.charcoal.withValues(alpha: 0.6)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                        : (isDark
                            ? AppColors.blue900.withValues(alpha: 0.3)
                            : AppColors.lightGray300),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Document Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(widget.document.type, isDark)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.document.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(widget.document.type, isDark),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Title
                    Text(
                      widget.document.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Version
                    Text(
                      'Version ${widget.document.version}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.gray500
                            : AppColors.lightGray500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.document.tags
                          .take(3)
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.blue900.withValues(alpha: 0.3)
                                      : AppColors.lightGray200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.lightGray600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    // Updated Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isDark
                              ? AppColors.gray500
                              : AppColors.lightGray500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(widget.document.updatedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.lightGray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(DocumentType type, bool isDark) {
    switch (type) {
      case DocumentType.resume:
        return isDark ? AppColors.accentCyan : AppColors.primaryBlue;
      case DocumentType.coverLetter:
        return isDark ? AppColors.highlightGreen : const Color(0xFF4CAF50);
      case DocumentType.careerDescription:
        return isDark
            ? const Color(0xFFFF9800)
            : const Color(0xFFF57C00);
      case DocumentType.portfolio:
        return isDark
            ? const Color(0xFFE91E63)
            : const Color(0xFFC2185B);
      case DocumentType.requirements:
      case DocumentType.userFlow:
      case DocumentType.informationArchitecture:
      case DocumentType.wireframe:
        return isDark ? const Color(0xFF9C27B0) : const Color(0xFF7B1FA2);
      case DocumentType.projectCharter:
      case DocumentType.screenDesign:
      case DocumentType.stakeholderMatrix:
      case DocumentType.riskRegister:
      case DocumentType.changeLog:
      case DocumentType.lessonsLearned:
        return isDark ? const Color(0xFF3F51B5) : const Color(0xFF303F9F);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
