import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../portfolio/domain/models/portfolio_model.dart';
import '../../../portfolio/presentation/providers/portfolio_provider.dart';

class PortfolioEditorDialog extends ConsumerStatefulWidget {
  final PortfolioModel? portfolio; // null for create, non-null for edit

  const PortfolioEditorDialog({super.key, this.portfolio});

  @override
  ConsumerState<PortfolioEditorDialog> createState() =>
      _PortfolioEditorDialogState();
}

class _PortfolioEditorDialogState extends ConsumerState<PortfolioEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _companyController;
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _roleController;
  late TextEditingController _durationController;
  late TextEditingController _teamSizeController;
  late TextEditingController _achievementsController;
  late TextEditingController _technologiesController;
  late TextEditingController _gradientColor1Controller;
  late TextEditingController _gradientColor2Controller;
  late TextEditingController _orderController;
  late PortfolioCategory _selectedCategory;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.portfolio != null
        ? PortfolioCategory.fromValue(widget.portfolio!.category)
        : PortfolioCategory.mobileApp;

    _titleController = TextEditingController(
      text: widget.portfolio?.title ?? '',
    );
    _subtitleController = TextEditingController(
      text: widget.portfolio?.subtitle ?? '',
    );
    _companyController = TextEditingController(
      text: widget.portfolio?.company ?? '',
    );
    _yearController = TextEditingController(text: widget.portfolio?.year ?? '');
    _descriptionController = TextEditingController(
      text: widget.portfolio?.description ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.portfolio?.tags.join(', ') ?? '',
    );
    _roleController = TextEditingController(text: widget.portfolio?.role ?? '');
    _durationController = TextEditingController(
      text: widget.portfolio?.duration ?? '',
    );
    _teamSizeController = TextEditingController(
      text: widget.portfolio?.teamSize ?? '',
    );
    _achievementsController = TextEditingController(
      text: widget.portfolio?.achievements.join('\n') ?? '',
    );
    _technologiesController = TextEditingController(
      text: widget.portfolio?.technologies.join(', ') ?? '',
    );
    _gradientColor1Controller = TextEditingController(
      text: widget.portfolio?.gradientColors.isNotEmpty == true
          ? widget.portfolio!.gradientColors[0]
          : '#2196F3',
    );
    _gradientColor2Controller = TextEditingController(
      text: (widget.portfolio?.gradientColors.length ?? 0) >= 2
          ? widget.portfolio!.gradientColors[1]
          : '#00BCD4',
    );
    _orderController = TextEditingController(
      text: widget.portfolio?.order.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _companyController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _roleController.dispose();
    _durationController.dispose();
    _teamSizeController.dispose();
    _achievementsController.dispose();
    _technologiesController.dispose();
    _gradientColor1Controller.dispose();
    _gradientColor2Controller.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _savePortfolio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final achievements = _achievementsController.text
          .split('\n')
          .map((a) => a.trim())
          .where((a) => a.isNotEmpty)
          .toList();

      final technologies = _technologiesController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final gradientColors = [
        _gradientColor1Controller.text.trim(),
        _gradientColor2Controller.text.trim(),
      ];

      final order = int.tryParse(_orderController.text) ?? 0;

      if (widget.portfolio == null) {
        // Create new portfolio
        final newPortfolio = PortfolioModel(
          id: '', // Repository will generate
          title: _titleController.text,
          subtitle: _subtitleController.text,
          company: _companyController.text,
          year: _yearController.text,
          category: _selectedCategory.value,
          description: _descriptionController.text,
          tags: tags,
          gradientColors: gradientColors,
          role: _roleController.text,
          duration: _durationController.text,
          teamSize: _teamSizeController.text,
          achievements: achievements,
          technologies: technologies,
          order: order,
          createdAt: DateTime.now(), // Repository will override
          updatedAt: DateTime.now(), // Repository will override
        );
        await ref
            .read(portfoliosNotifierProvider.notifier)
            .createPortfolio(newPortfolio);
      } else {
        // Update existing portfolio
        final updatedPortfolio = PortfolioModel(
          id: widget.portfolio!.id,
          title: _titleController.text,
          subtitle: _subtitleController.text,
          company: _companyController.text,
          year: _yearController.text,
          category: _selectedCategory.value,
          description: _descriptionController.text,
          tags: tags,
          gradientColors: gradientColors,
          role: _roleController.text,
          duration: _durationController.text,
          teamSize: _teamSizeController.text,
          achievements: achievements,
          technologies: technologies,
          order: order,
          createdAt: widget.portfolio!.createdAt,
          updatedAt: DateTime.now(),
        );
        await ref
            .read(portfoliosNotifierProvider.notifier)
            .updatePortfolio(updatedPortfolio);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.portfolio == null ? '프로젝트가 추가되었습니다' : '프로젝트가 수정되었습니다',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Dialog(
      backgroundColor: isDark ? AppColors.charcoal : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isMobile ? size.width * 0.9 : 700,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryBlue.withValues(alpha: 0.1)
                    : AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.work,
                    color: isDark
                        ? AppColors.accentCyan
                        : AppColors.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.portfolio == null ? '새 프로젝트 추가' : '프로젝트 수정',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Basic Info
                      _buildSectionTitle('기본 정보', isDark),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _titleController,
                        label: '프로젝트 제목',
                        hint: 'AIA+ SENIOR MODE',
                        isDark: isDark,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _subtitleController,
                        label: '부제목',
                        hint: '고령자 전용 모드 UX/UI 디자인 시스템',
                        isDark: isDark,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _companyController,
                              label: '회사/클라이언트',
                              hint: 'ING People',
                              isDark: isDark,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _yearController,
                              label: '기간',
                              hint: '2025.02-2025.06',
                              isDark: isDark,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildCategoryDropdown(isDark),
                      const SizedBox(height: 24),

                      // Section: Description
                      _buildSectionTitle('프로젝트 설명', isDark),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _descriptionController,
                        label: '설명',
                        hint: '프로젝트에 대한 상세 설명을 입력하세요',
                        isDark: isDark,
                        maxLines: 4,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Section: Project Details
                      _buildSectionTitle('프로젝트 상세', isDark),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _roleController,
                              label: '역할',
                              hint: 'Product Designer',
                              isDark: isDark,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _durationController,
                              label: '작업 기간',
                              hint: '5개월',
                              isDark: isDark,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _teamSizeController,
                        label: '팀 규모',
                        hint: '8명',
                        isDark: isDark,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Section: Lists
                      _buildSectionTitle('태그 및 기술', isDark),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _tagsController,
                        label: '태그 (쉼표로 구분)',
                        hint: 'Figma, Mobile UX, Design System',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _technologiesController,
                        label: '기술 스택 (쉼표로 구분)',
                        hint: 'Figma, Sketch, Adobe XD',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),

                      // Section: Achievements
                      _buildSectionTitle('주요 성과', isDark),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _achievementsController,
                        label: '성과 (줄바꿈으로 구분)',
                        hint: '사용성 테스트 결과 90% 만족도\n접근성 WCAG 2.1 AA 준수',
                        isDark: isDark,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 24),

                      // Section: Visual
                      _buildSectionTitle('비주얼 설정', isDark),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildColorField(
                              controller: _gradientColor1Controller,
                              label: '그라디언트 색상 1',
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildColorField(
                              controller: _gradientColor2Controller,
                              label: '그라디언트 색상 2',
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _orderController,
                        label: '정렬 순서',
                        hint: '0',
                        isDark: isDark,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Buttons
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.lightGray600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _savePortfolio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.accentCyan
                          : AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.portfolio == null ? '추가' : '저장',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.gray300 : AppColors.lightGray700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.gray500 : AppColors.lightGray400,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.charcoal.withValues(alpha: 0.3)
                : AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 12,
            ),
          ),
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
          ),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label을(를) 입력해주세요';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.gray300 : AppColors.lightGray700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<PortfolioCategory>(
          // ignore: deprecated_member_use
          value: _selectedCategory,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? AppColors.charcoal.withValues(alpha: 0.3)
                : AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          dropdownColor: isDark ? AppColors.charcoal : Colors.white,
          items: PortfolioCategory.values
              .where((cat) => cat != PortfolioCategory.all)
              .map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.displayName,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.gray100
                          : AppColors.lightGray900,
                    ),
                  ),
                );
              })
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedCategory = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildColorField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.gray300 : AppColors.lightGray700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: '#2196F3',
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.gray500 : AppColors.lightGray400,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.charcoal.withValues(alpha: 0.3)
                      : AppColors.gray100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _parseColor(controller.text),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.gray600 : AppColors.gray300,
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return AppColors.primaryBlue;
    } catch (e) {
      return AppColors.primaryBlue;
    }
  }
}
