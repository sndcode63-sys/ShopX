import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return Icon(Icons.star_rounded, color: AppTheme.warning, size: size);
          } else if (i < rating) {
            return Icon(Icons.star_half_rounded, color: AppTheme.warning, size: size);
          }
          return Icon(Icons.star_outline_rounded, color: AppTheme.textMuted, size: size);
        }),
        const SizedBox(width: 4),
        Text(
          '($reviewCount)',
          style: AppTheme.labelSmall,
        ),
      ],
    );
  }
}
