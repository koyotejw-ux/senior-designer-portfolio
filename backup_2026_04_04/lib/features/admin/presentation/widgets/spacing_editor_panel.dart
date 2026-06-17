import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/ui_settings_model.dart';
import '../providers/ui_settings_provider.dart';

class SpacingEditorPanel extends ConsumerStatefulWidget {
  const SpacingEditorPanel({super.key});

  @override
  ConsumerState<SpacingEditorPanel> createState() => _SpacingEditorPanelState();
}

class _SpacingEditorPanelState extends ConsumerState<SpacingEditorPanel> {
  // Resume Page Spacing
  double _resumeMobileSpacing = 60;
  double _resumeTabletSpacing = 80;
  double _resumeDesktopSpacing = 100;

  // Portfolio Page Spacing
  double _portfolioMobileSpacing = 60;
  double _portfolioTabletSpacing = 80;
  double _portfolioDesktopSpacing = 100;

  // Documents Page Spacing
  double _documentsMobileSpacing = 60;
  double _documentsTabletSpacing = 80;
  double _documentsDesktopSpacing = 100;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load initial settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  void _loadSettings() {
    final settingsAsync = ref.read(uiSettingsProvider);
    settingsAsync.whenData((settings) {
      if (mounted) {
        setState(() {
          _resumeMobileSpacing = settings.resumeSpacing.mobile;
          _resumeTabletSpacing = settings.resumeSpacing.tablet;
          _resumeDesktopSpacing = settings.resumeSpacing.desktop;

          _portfolioMobileSpacing = settings.portfolioSpacing.mobile;
          _portfolioTabletSpacing = settings.portfolioSpacing.tablet;
          _portfolioDesktopSpacing = settings.portfolioSpacing.desktop;

          _documentsMobileSpacing = settings.documentsSpacing.mobile;
          _documentsTabletSpacing = settings.documentsSpacing.tablet;
          _documentsDesktopSpacing = settings.documentsSpacing.desktop;
        });
      }
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);

    try {
      await ref.read(uiSettingsProvider.notifier).updateAllSpacings(
            resumeSpacing: PageSpacing(
              mobile: _resumeMobileSpacing,
              tablet: _resumeTabletSpacing,
              desktop: _resumeDesktopSpacing,
            ),
            portfolioSpacing: PageSpacing(
              mobile: _portfolioMobileSpacing,
              tablet: _portfolioTabletSpacing,
              desktop: _portfolioDesktopSpacing,
            ),
            documentsSpacing: PageSpacing(
              mobile: _documentsMobileSpacing,
              tablet: _documentsTabletSpacing,
              desktop: _documentsDesktopSpacing,
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('설정이 저장되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: Colors.red,
          ),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            color: isDark ? AppColors.charcoal : Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'UI 간격 설정',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '각 페이지의 섹션 간격을 디바이스별로 설정할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Resume Page Settings
          _buildPageSettings(
            isDark,
            isMobile,
            title: 'Resume 페이지',
            icon: Icons.description,
            color: AppColors.primaryBlue,
            mobileValue: _resumeMobileSpacing,
            tabletValue: _resumeTabletSpacing,
            desktopValue: _resumeDesktopSpacing,
            onMobileChanged: (v) => setState(() => _resumeMobileSpacing = v),
            onTabletChanged: (v) => setState(() => _resumeTabletSpacing = v),
            onDesktopChanged: (v) => setState(() => _resumeDesktopSpacing = v),
          ),

          const SizedBox(height: 24),

          // Portfolio Page Settings
          _buildPageSettings(
            isDark,
            isMobile,
            title: 'Portfolio 페이지',
            icon: Icons.work,
            color: AppColors.accentCyan,
            mobileValue: _portfolioMobileSpacing,
            tabletValue: _portfolioTabletSpacing,
            desktopValue: _portfolioDesktopSpacing,
            onMobileChanged: (v) => setState(() => _portfolioMobileSpacing = v),
            onTabletChanged: (v) => setState(() => _portfolioTabletSpacing = v),
            onDesktopChanged: (v) => setState(() => _portfolioDesktopSpacing = v),
          ),

          const SizedBox(height: 24),

          // Documents Page Settings
          _buildPageSettings(
            isDark,
            isMobile,
            title: 'Documents 페이지',
            icon: Icons.folder,
            color: AppColors.highlightGreen,
            mobileValue: _documentsMobileSpacing,
            tabletValue: _documentsTabletSpacing,
            desktopValue: _documentsDesktopSpacing,
            onMobileChanged: (v) => setState(() => _documentsMobileSpacing = v),
            onTabletChanged: (v) => setState(() => _documentsTabletSpacing = v),
            onDesktopChanged: (v) => setState(() => _documentsDesktopSpacing = v),
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '설정 저장',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPageSettings(
    bool isDark,
    bool isMobile, {
    required String title,
    required IconData icon,
    required Color color,
    required double mobileValue,
    required double tabletValue,
    required double desktopValue,
    required ValueChanged<double> onMobileChanged,
    required ValueChanged<double> onTabletChanged,
    required ValueChanged<double> onDesktopChanged,
  }) {
    return Card(
      color: isDark ? AppColors.charcoal : Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Mobile Spacing
            _buildSpacingSlider(
              isDark,
              label: 'Mobile 간격',
              value: mobileValue,
              onChanged: onMobileChanged,
              color: color,
            ),
            const SizedBox(height: 20),

            // Tablet Spacing
            _buildSpacingSlider(
              isDark,
              label: 'Tablet 간격',
              value: tabletValue,
              onChanged: onTabletChanged,
              color: color,
            ),
            const SizedBox(height: 20),

            // Desktop Spacing
            _buildSpacingSlider(
              isDark,
              label: 'Desktop 간격',
              value: desktopValue,
              onChanged: onDesktopChanged,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingSlider(
    bool isDark, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.gray300 : AppColors.lightGray700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toInt()}px',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 20,
            max: 200,
            divisions: 18,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
