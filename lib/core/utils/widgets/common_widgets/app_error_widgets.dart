import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import 'gradient_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: AppTheme.accent, size: 40),
            ),
            const SizedBox(height: 24),
            Text('Oops! Something went wrong',
                style: AppTheme.headingMedium, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(message,
                style: AppTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 28),
            GradientButton(
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}