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
    // Simulate loading progress
    // In a real scenario, this would listen to image streams or data fetching
    const totalDuration = Duration(seconds: 3);
    const steps = 100;
    final stepDuration = Duration(
      milliseconds: totalDuration.inMilliseconds ~/ steps,
    );

    _timer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        _progress += 0.01;
      });

      if (_progress >= 1.0) {
        _progress = 1.0;
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), widget.onCompleted);
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
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  // Filled Progress
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 300 * _progress,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCyan.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
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
                color: AppColors.gray100.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLoadingText(int percentage) {
    if (percentage < 20) return 'Loading Core Modules...';
    if (percentage < 40) return 'Establishing Secure Connection...';
    if (percentage < 60) return 'Fetching Portfolio Data...';
    if (percentage < 80) return 'Optimizing Assets...';
    return 'Ready to Launch.';
  }
}
