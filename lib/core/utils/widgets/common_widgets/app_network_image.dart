import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/app_theme.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: AppTheme.shimmerBase,
          highlightColor: AppTheme.shimmerHighlight,
          child: Container(
            width: width,
            height: height,
            color: AppTheme.shimmerBase,
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppTheme.bgSurface,
          child: const Icon(Icons.image_not_supported_rounded,
              color: AppTheme.textMuted, size: 28),
        ),
      ),
    );
  }
}
