import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/theme_toggle.dart';
import '../../core/utils/widgets/common_widgets/app_error_widgets.dart';
import '../../core/utils/widgets/common_widgets/empty_card.dart';
import '../../core/utils/widgets/common_widgets/product_simmer_card.dart';
import '../../core/utils/widgets/product_card.dart';
import '../controllers/cart_controllers.dart';
import '../controllers/product_controllers.dart';
import '../controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final cartCtrl = Get.find<CartController>();

    return Obx(() {
      final t = ThemeController.to.theme;
      return Scaffold(
        backgroundColor: t.bgDark,
        body: SafeArea(
          child: Column(
            children: [
              _HomeAppBar(cartCtrl: cartCtrl),
              _SearchBar(controller: productCtrl),
              _CategoryFilter(controller: productCtrl),
              const SizedBox(height: 8),
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
                    physics: const BouncingScrollPhysics(),
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
    });
  }
}

//  App Bar
class _HomeAppBar extends StatelessWidget {
  final CartController cartCtrl;
  const _HomeAppBar({required this.cartCtrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
        child: Row(
          children: [
            // Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: t.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ShopX', style: t.headingLarge),
                Text('Discover premium products', style: t.labelSmall),
              ],
            ),
            const Spacer(),

            // Theme toggle
            const ThemeToggleButton(),
            const SizedBox(width: 10),

            // Cart icon with badge
            Obx(() => GestureDetector(
                  onTap: () => Get.toNamed(AppConstants.cartRoute),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: t.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: t.divider),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            color: t.textPrimary, size: 24),
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
                                gradient: t.accentGradient,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                '${cartCtrl.itemCount}',
                                style: t.labelSmall.copyWith(
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
    });
  }
}

//  Search Bar
class _SearchBar extends StatelessWidget {
  final ProductController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: t.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.divider),
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
          child: TextField(
            onChanged: controller.search,
            style: t.bodyLarge.copyWith(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: t.bodyMedium,
              prefixIcon:
                  Icon(Icons.search_rounded, color: t.textMuted, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    });
  }
}

//  Category Filter
class _CategoryFilter extends StatelessWidget {
  final ProductController controller;
  const _CategoryFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      final categories = controller.categories;
      final selected = controller.selectedCategory;

      return SizedBox(
        height: 38,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
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
                decoration: isSelected
                    ? BoxDecoration(
                        gradient: t.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                        border: Border.all(color: Colors.transparent),
                      )
                    : BoxDecoration(
                        color: t.bgCard,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                        border: Border.all(color: t.divider),
                      ),
                child: Center(
                  child: Text(
                    cat == 'all' ? 'All' : cat.capitalizeFirst!,
                    style: t.labelSmall.copyWith(
                      color: isSelected ? Colors.white : t.textSecondary,
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

//  Shimmer List
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
