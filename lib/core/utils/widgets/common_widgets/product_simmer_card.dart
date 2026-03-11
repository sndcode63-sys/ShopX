import 'package:flutter/cupertino.dart';
import 'package:shop_x/core/utils/widgets/common_widgets/simmer_box.dart';

import '../../../theme/app_theme.dart';

class ProductShimmerCard extends StatelessWidget {
  const ProductShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider, width: 1),
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
  }
}
