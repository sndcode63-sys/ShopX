import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../presentation/controllers/theme_controller.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;

  const AppNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: t.shimmerBase,
            highlightColor: t.shimmerHighlight,
            child: Container(
              width: width,
              height: height,
              color: t.shimmerBase,
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            width: width,
            height: height,
            color: t.bgSurface,
            child: Icon(
              Icons.image_not_supported_rounded,
              color: t.textMuted,
              size: 28,
            ),
          ),
        ),
      );
    });
  }
}