import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../presentation/controllers/theme_controller.dart';
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
    return Obx(() {
      final t = ThemeController.to.theme;
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
                  color: t.bgCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: t.divider),
                  boxShadow: t.isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Icon(Icons.wifi_off_rounded, color: t.accent, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: t.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: t.bodyMedium,
                textAlign: TextAlign.center,
              ),
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
    });
  }
}
