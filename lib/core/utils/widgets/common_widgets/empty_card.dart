import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              color: AppTheme.textMuted, size: 60),
          const SizedBox(height: 16),
          Text('No products found', style: AppTheme.headingMedium),
          const SizedBox(height: 8),
          Text('Try a different search or category',
              style: AppTheme.bodyMedium),
        ],
      ),
    );
  }
}