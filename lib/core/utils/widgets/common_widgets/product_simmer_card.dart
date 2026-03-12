import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../presentation/controllers/theme_controller.dart';
import 'simmer_box.dart';

class ProductShimmerCard extends StatelessWidget {
  const ProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: t.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.divider, width: 1),
          boxShadow: t.isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: const Row(
          children: [
            ShimmerBox(width: 90, height: 90, radius: 14),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(width: 180, height: 12),
                  SizedBox(height: 12),
                  ShimmerBox(width: 80, height: 18, radius: 8),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
