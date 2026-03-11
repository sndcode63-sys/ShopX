import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/widgets/common_widgets/app_error_widgets.dart';
import '../../core/utils/widgets/common_widgets/empty_card.dart';
import '../../core/utils/widgets/common_widgets/product_simmer_card.dart';
import '../../core/utils/widgets/product_card.dart';
import '../controllers/cart_controllers.dart';
import '../controllers/product_controllers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final cartCtrl = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            //  App Bar
            _HomeAppBar(cartCtrl: cartCtrl),

            //  Search Bar
            _SearchBar(controller: productCtrl),

            //  Category Filter
            _CategoryFilter(controller: productCtrl),

            const SizedBox(height: 8),

            //  Products List
            Expanded(
              child: Obx(() {
                if (productCtrl.isLoading) return const _ShimmerList();
                if (productCtrl.hasError) {
                  return AppErrorWidget(
                    message: productCtrl.errorMessage,
                    onRetry: productCtrl.retry,
                  );
                }
                if (productCtrl.products.isEmpty) return const EmptyState();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: productCtrl.products.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: productCtrl.products[i],
                    index: i,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  final CartController cartCtrl;
  const _HomeAppBar({required this.cartCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ShopX', style: AppTheme.headingLarge),
              Text('Discover premium products', style: AppTheme.labelSmall),
            ],
          ),
          const Spacer(),

          // Cart icon with badge
          Obx(() => GestureDetector(
            onTap: () => Get.toNamed(AppConstants.cartRoute),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      color: AppTheme.textPrimary, size: 24),
                  if (cartCtrl.itemCount > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${cartCtrl.itemCount}',
                          style: AppTheme.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}


class _SearchBar extends StatelessWidget {
  final ProductController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: TextField(
          onChanged: controller.search,
          style: AppTheme.bodyLarge.copyWith(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: AppTheme.bodyMedium,
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppTheme.textMuted, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

//  Category Filter
class _CategoryFilter extends StatelessWidget {
  final ProductController controller;
  const _CategoryFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      final selected = controller.selectedCategory;

      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = categories[i];
            final isSelected = selected == cat;

            return GestureDetector(
              onTap: () => controller.filterByCategory(cat),
              child: AnimatedContainer(
                duration: AppConstants.animFast,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // ✅ FIX: gradient aur color ek saath nahi chalte BoxDecoration mein
                // Isliye selected/unselected ke liye alag BoxDecoration banaya
                decoration: isSelected
                    ? BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius:
                  BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(color: Colors.transparent),
                )
                    : BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius:
                  BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Center(
                  child: Text(
                    cat == 'all' ? 'All' : cat.capitalizeFirst!,
                    style: AppTheme.labelSmall.copyWith(
                      color:
                      isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductShimmerCard(),
    );
  }
}

