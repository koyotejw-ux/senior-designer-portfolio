import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const LoadingScreen({super.key, required this.onCompleted});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    // Extremely fast animation (approx 100ms)
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _progress += 0.2;
        });

        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          widget.onCompleted();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_progress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glitchy/Tech Text
            Text(
              'INITIALIZING SYSTEM...',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accentCyan,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Progress Bar Container
            Container(
              width: 300,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.all(1.5),
              child: Stack(
                children: [
                  // Filled Progress (Solid flat plane)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 297 * _progress,
                    height: double.infinity,
                    color: AppColors.accentCyan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Percentage Text
            Text(
              '$percentage%',
              style: AppTypography.h3.copyWith(
                color: Colors.white,
                fontFamily: 'Courier', // Monospace for tech feel
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Loading Details (Simulated)
            Text(
              _getLoadingText(percentage),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray100.withValues(alpha: 0.7),
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),

            // Telemetry Logs Console
            Container(
              width: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  width: 1.0,
                ),
              ),
              child: Text(
                _getSystemLogs(percentage),
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: 10,
                  fontFamily: 'Courier',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLoadingText(int percentage) {
    if (percentage < 20) return 'LOADING CORE MODULES...';
    if (percentage < 40) return 'ESTABLISHING SECURE CONN...';
    if (percentage < 60) return 'FETCHING PORTFOLIO DB...';
    if (percentage < 80) return 'OPTIMIZING GRAPHICS ENGINE...';
    return 'READY TO LAUNCH.';
  }

  String _getSystemLogs(int percentage) {
    final List<String> logs = [
      '>> SYS.INIT: OK',
      '>> DB.PORT: 8080 CONNECTED',
      '>> RENDER.ENGINE: DART_VULKAN',
    ];
    if (percentage > 25) logs.add('>> UX.STRAT.MOD: ACTIVE');
    if (percentage > 50) logs.add('>> FIGMA.DF_SYS: PARSED');
    if (percentage > 75) logs.add('>> MES.ERP.STABLE: 100%');
    if (percentage >= 100) logs.add('>> BOOT.SEQ: COMPLETED');

    // Return last 3 logs
    if (logs.length > 3) {
      return logs.sublist(logs.length - 3).join('\n');
    }
    return logs.join('\n');
  }
}
