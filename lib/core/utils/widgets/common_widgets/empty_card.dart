import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../presentation/controllers/theme_controller.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, color: t.textMuted, size: 60),
            const SizedBox(height: 16),
            Text('No products found', style: t.headingMedium),
            const SizedBox(height: 8),
            Text('Try a different search or category', style: t.bodyMedium),
          ],
        ),
      );
    });
  }
}
