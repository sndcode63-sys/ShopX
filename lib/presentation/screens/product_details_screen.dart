import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/utils/widgets/common_widgets/360_degree_view.dart';
import '../../data/models/product_model.dart';
import '../controllers/cart_controllers.dart';
import '../controllers/theme_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic argumentData = Get.arguments;
    final ProductModel? product =
    argumentData is ProductModel ? argumentData : null;

    if (product == null) {
      return Obx(() {
        final t = ThemeController.to.theme;
        return Scaffold(
          backgroundColor: t.bgDark,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, color: t.accent, size: 60),
                const SizedBox(height: 16),
                Text('Product data missing',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: t.textPrimary,
                    )),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text('Go Back',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: t.primary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),
        );
      });
    }

    final cart = Get.find<CartController>();

    return Obx(() {
      final t = ThemeController.to.theme;
      return Scaffold(
        backgroundColor: t.bgDark,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 340,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: t.bgCard,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Product360View(product: product),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Get.back(),
                            ),
                            _NavButton(
                              icon: Icons.share_rounded,
                              onTap: () {
                                SharePlus.instance.share(
                                  ShareParams(
                                    text: '🛍️ ${product.title}\n\n'
                                        '💰 Price: ${product.formattedPrice}\n'
                                        '⭐ Rating: ${product.rating.rate}/5 (${product.rating.count} reviews)\n'
                                        '📦 Category: ${product.categoryLabel}\n\n'
                                        'Shared via ShopX App',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryBadge(label: product.categoryLabel),
                    const SizedBox(height: 12),
                    Text(
                      product.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: t.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.formattedPrice,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: t.success,
                          ),
                        ),
                        _RatingChip(product: product),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: t.divider, height: 1),
                    const SizedBox(height: 20),
                    Text('Description',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: t.textPrimary,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      product.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: t.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ReviewsCard(product: product),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomBar(product: product, cart: cart),
      );
    });
  }
}

// Nav Button
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: t.bgCard.withOpacity(0.9),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: t.divider),
          ),
          child: Icon(icon, color: t.textPrimary, size: 18),
        ),
      );
    });
  }
}

// Category Badge
class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: t.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.primary.withOpacity(0.3)),
        ),
        child: Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: t.primary,
              letterSpacing: 0.5,
            )),
      );
    });
  }
}

//  Rating Chip
class _RatingChip extends StatelessWidget {
  final ProductModel product;
  const _RatingChip({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: t.warning.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.warning.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(Icons.star_rounded, color: t.warning, size: 18),
          const SizedBox(width: 5),
          Text('${product.rating.rate}',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: t.warning)),
          Text('  ·  ${product.rating.count} reviews',
              style: GoogleFonts.dmSans(
                  fontSize: 12, color: t.textSecondary)),
        ]),
      );
    });
  }
}

//  Reviews Card
class _ReviewsCard extends StatelessWidget {
  final ProductModel product;
  const _ReviewsCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.divider),
          boxShadow: t.isDark
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          Column(children: [
            Text('${product.rating.rate}',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: t.warning)),
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < product.rating.rate.floor()
                      ? Icons.star_rounded
                      : i < product.rating.rate
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
                  color: t.warning,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text('${product.rating.count} reviews',
                style: GoogleFonts.dmSans(
                    fontSize: 11, color: t.textMuted)),
          ]),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(children: [
              _RatingBar(label: '5', value: 0.7),
              _RatingBar(label: '4', value: 0.15),
              _RatingBar(label: '3', value: 0.08),
              _RatingBar(label: '2', value: 0.04),
              _RatingBar(label: '1', value: 0.03),
            ]),
          ),
        ]),
      );
    });
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double value;
  const _RatingBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Text(label,
              style: GoogleFonts.dmSans(
                  fontSize: 11, color: t.textMuted)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: t.bgSurface,
                valueColor: AlwaysStoppedAnimation<Color>(t.warning),
                minHeight: 5,
              ),
            ),
          ),
        ]),
      );
    });
  }
}

//  Bottom Bar
class _BottomBar extends StatelessWidget {
  final ProductModel product;
  final CartController cart;
  const _BottomBar({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      final inCart = cart.isInCart(product.id);
      final qty = cart.quantityOf(product.id);

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: BoxDecoration(
          color: t.bgCard,
          border: Border(top: BorderSide(color: t.divider)),
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: t.isDark
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inCart ? 'Total ($qty Item)' : 'Price',
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: t.textMuted),
              ),
              Text(
                inCart
                    ? '₹${(product.price * qty * 83).toStringAsFixed(0)}'
                    : product.formattedPrice,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: t.success),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: inCart
                ? _InCartRow(
              qty: qty,
              onInc: () {
                HapticFeedback.lightImpact();
                cart.increaseQuantity(product.id);
              },
              onDec: () {
                HapticFeedback.lightImpact();
                cart.decreaseQuantity(product.id);
              },
            )
                : _AddToCartButton(
              onTap: () {
                HapticFeedback.mediumImpact();
                cart.addToCart(product);
              },
            ),
          ),
        ]),
      );
    });
  }
}

//  Add to Cart Button
class _AddToCartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddToCartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: t.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: t.primary.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Add to Cart',
                  style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      );
    });
  }
}

//  In Cart Row
class _InCartRow extends StatelessWidget {
  final int qty;
  final VoidCallback onInc, onDec;
  const _InCartRow(
      {required this.qty, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ThemeController.to.theme;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: t.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.primary.withOpacity(0.3)),
        ),
        child: Row(children: [
          _Btn(
            icon: qty <= 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            color: qty <= 1 ? t.accent : t.primary,
            onTap: onDec,
          ),
          Expanded(
            child: Center(
              child: Text('$qty in cart',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.primary)),
            ),
          ),
          _Btn(icon: Icons.add_rounded, color: t.primary, onTap: onInc),
        ]),
      );
    });
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Btn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: color, size: 20)),
    );
  }
}