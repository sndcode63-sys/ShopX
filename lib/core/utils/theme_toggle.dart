import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = ThemeController.to;
    return Obx(() {
      final isDark = ctrl.isDark;
      final t = ctrl.theme;
      return GestureDetector(
        onTap: ctrl.toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 56,
          height: 30,
          decoration: BoxDecoration(
            gradient: isDark ? t.primaryGradient : null,
            color: isDark ? null : t.bgSurface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: t.divider),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : t.bgCard,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: t.primary.withOpacity(0.3),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 14,
                  color: isDark ? t.primary : t.warning,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
