import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import 'holographic_card.dart';

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  void _showEmailForm(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => _EmailFormDialog(isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 100 : 140,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Section Header
              Column(
                children: [
                  Text(
                    '06.SYS_CONN',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      fontSize: isMobile ? 32 : 54,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Let's Work Together",
                    style: (isMobile ? AppTypography.h3 : AppTypography.h1)
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 16 : 24),

              // Subtitle
              Text(
                    '대기업 프로젝트 경험과 AI/데이터 전문성을 갖춘 시니어 디자이너와 함께하세요',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.gray100.withValues(alpha: 0.8),
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 64),

              // Contact Cards Grid
              isMobile
                  ? Column(
                      children: [
                        _buildContactCard(
                          Icons.email_outlined,
                          'Email',
                          AppConstants.email,
                          AppColors.accentCyan,
                          isDark,
                          0,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          Icons.phone_outlined,
                          'Phone',
                          AppConstants.phone,
                          AppColors.highlightGreen,
                          isDark,
                          1,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          Icons.location_on_outlined,
                          'Location',
                          '고양시 덕양구 향기5로 66',
                          AppColors.primaryBlue,
                          isDark,
                          2,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildContactCard(
                            Icons.email_outlined,
                            'Email',
                            AppConstants.email,
                            AppColors.accentCyan,
                            isDark,
                            0,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildContactCard(
                            Icons.phone_outlined,
                            'Phone',
                            AppConstants.phone,
                            AppColors.highlightGreen,
                            isDark,
                            1,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildContactCard(
                            Icons.location_on_outlined,
                            'Location',
                            '고양시 덕양구 향기5로 66',
                            AppColors.primaryBlue,
                            isDark,
                            2,
                          ),
                        ),
                      ],
                    ),

              SizedBox(height: isMobile ? 48 : 64),

              // CTA Button
              GestureDetector(
                    onTap: () => _showEmailForm(context, isDark),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryBlue, AppColors.accentCyan],
                        ),
                        borderRadius: BorderRadius.zero,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Send Message',
                            style: AppTypography.h6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.send, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 64 : 80),

              // Footer
              Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '© 2026 Jaewoong Jung. All rights reserved.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray100.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 8),
                    // Hidden Admin Access
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => GoRouter.of(context).go('/admin'),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 16,
                          color: AppColors.gray100.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    Color accentColor,
    bool isDark,
    int index,
  ) {
    return HolographicCard(
      title: title,
      accentColor: accentColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: accentColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (400 + index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class _EmailFormDialog extends StatefulWidget {
  final bool isDark;

  const _EmailFormDialog({required this.isDark});

  @override
  State<_EmailFormDialog> createState() => _EmailFormDialogState();
}

class _EmailFormDialogState extends State<_EmailFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: AppConstants.email,
        query: _encodeQueryParameters(<String, String>{
          'subject': 'Portfolio Contact from ${_nameController.text}',
          'body':
              'From: ${_nameController.text} (${_emailController.text})\n\n${_messageController.text}',
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        if (mounted) Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppColors.charcoal,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: AppColors.gray600.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.primaryBlue),
      ),
      labelStyle: TextStyle(
        color: AppColors.gray300,
      ),
    );

    return Dialog(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send Message',
                style: AppTypography.h4.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: inputDecoration.copyWith(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: inputDecoration.copyWith(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: inputDecoration.copyWith(labelText: 'Message'),
                maxLines: 4,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.gray300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
