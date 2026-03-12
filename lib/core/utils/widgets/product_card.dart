import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../presentation/controllers/cart_controllers.dart';
import '../../../presentation/controllers/theme_controller.dart';
import '../../constants/app_constants.dart';
import 'common_widgets/app_network_image.dart';
import 'common_widgets/rating_stars.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: child,
        ),
      ),
      child: Obx(() {
        final t = ThemeController.to.theme;
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: t.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: t.divider, width: 1),
            boxShadow: t.isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: t.primary.withOpacity(0.08),
              onTap: () => Get.toNamed(
                AppConstants.productDetailRoute,
                arguments: product,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductImage(product: product),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ProductInfo(product: product, cart: cart),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

//  Product Image
class _ProductImage extends StatelessWidget {
  final ProductModel product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        width: 95,
        height: 110,
        decoration: BoxDecoration(
          color: t.isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.divider, width: 1),
        ),
        padding: const EdgeInsets.all(8),
        child: AppNetworkImage(
          url: product.image,
          width: 79,
          height: 94,
          fit: BoxFit.contain,
          radius: 8,
        ),
      );
    });
  }
}

//  Product Info
class _ProductInfo extends StatelessWidget {
  final ProductModel product;
  final CartController cart;
  const _ProductInfo({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryBadge(label: product.categoryLabel),
          const SizedBox(height: 6),
          Text(
            product.shortTitle,
            style: t.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          RatingStars(
            rating: product.rating.rate,
            reviewCount: product.rating.count,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final inCart = cart.isInCart(product.id);
                final qty = cart.quantityOf(product.id);
                final displayPrice = inCart
                    ? '₹${(product.price * qty * 83).toStringAsFixed(0)}'
                    : product.formattedPrice;
                return Text(displayPrice, style: t.priceMedium);
              }),
              Obx(() {
                final inCart = cart.isInCart(product.id);
                final qty = cart.quantityOf(product.id);
                return inCart
                    ? _QuantityControl(
                        quantity: qty,
                        onIncrease: () {
                          HapticFeedback.lightImpact();
                          cart.increaseQuantity(product.id);
                        },
                        onDecrease: () {
                          HapticFeedback.lightImpact();
                          cart.decreaseQuantity(product.id);
                        },
                      )
                    : _AddButton(onTap: () {
                        HapticFeedback.mediumImpact();
                        cart.addToCart(product);
                      });
              }),
            ],
          ),
        ],
      );
    });
  }
}

//  Category Badge
class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: t.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: t.primary.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: t.labelSmall.copyWith(color: t.primary),
        ),
      );
    });
  }
}

//  Add Button
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: t.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: t.primary.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: t.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

//  Quantity Control
class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        decoration: BoxDecoration(
          color: t.bgSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: t.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QtyBtn(
              icon: quantity <= 1
                  ? Icons.delete_outline_rounded
                  : Icons.remove_rounded,
              color: quantity <= 1 ? t.accent : t.primary,
              onTap: onDecrease,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$quantity',
                style: t.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: t.primary,
                ),
              ),
            ),
            _QtyBtn(
              icon: Icons.add_rounded,
              color: t.primary,
              onTap: onIncrease,
            ),
          ],
        ),
      );
    });
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
