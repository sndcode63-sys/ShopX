import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../core/theme/app_theme.dart';
import '../../../core/utils/widgets/common_widgets/app_network_image.dart';
import '../../../core/utils/widgets/common_widgets/gradient_button.dart';
import '../../../data/models/cart models.dart';
import '../../controllers/cart_controllers.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // App Bar
            _CartAppBar(itemCount: cart.itemCount),

            //  Content
            Expanded(
              child: cart.isEmpty
                  ? const _EmptyCart()
                  : _CartContent(cart: cart),
            ),

            //  Checkout Bar
            if (!cart.isEmpty) _CheckoutBar(cart: cart),
          ],
        )),
      ),
    );
  }
}

//  App Bar
class _CartAppBar extends StatelessWidget {
  final int itemCount;
  const _CartAppBar({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary, size: 16),
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Cart', style: AppTheme.headingLarge),
              Text('$itemCount item${itemCount != 1 ? 's' : ''}',
                  style: AppTheme.labelSmall),
            ],
          ),
          const Spacer(),
          if (itemCount > 0)
            TextButton(
              onPressed: () => _showClearDialog(),
              child: Text('Clear all',
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.accent)),
            ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear Cart?', style: AppTheme.headingMedium),
        content: Text('Remove all items from your cart?',
            style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Get.find<CartController>().clearCart();
              Get.back();
            },
            child: Text('Clear',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.accent)),
          ),
        ],
      ),
    );
  }
}

//  Cart Content
class _CartContent extends StatelessWidget {
  final CartController cart;
  const _CartContent({required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: cart.items.length,
      itemBuilder: (_, i) => _CartItemCard(
        item: cart.items[i],
        index: i,
        cart: cart,
      ),
    );
  }
}

//  Cart Item Card
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final CartController cart;

  const _CartItemCard({
    required this.item,
    required this.index,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (_, val, child) => Opacity(
        opacity: val,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - val)),
          child: child,
        ),
      ),
      child: Dismissible(
        key: ValueKey(item.product.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(Icons.delete_outline_rounded,
              color: AppTheme.accent, size: 28),
        ),
        onDismissed: (_) {
          HapticFeedback.mediumImpact();
          cart.removeFromCart(item.product.id);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                padding: const EdgeInsets.all(6),
                child: AppNetworkImage(
                  url: item.product.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.contain,
                  radius: 8,
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.shortTitle,
                      style: AppTheme.bodyLarge.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(item.product.categoryLabel,
                        style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.primary)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.formattedTotal,
                            style: AppTheme.priceMedium),
                        _QuantityRow(item: item, cart: cart),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityRow extends StatelessWidget {
  final CartItem item;
  final CartController cart;
  const _QuantityRow({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QBtn(
            icon: item.quantity <= 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            color: item.quantity <= 1 ? AppTheme.accent : AppTheme.primary,
            onTap: () {
              HapticFeedback.lightImpact();
              cart.decreaseQuantity(item.product.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${item.quantity}',
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          _QBtn(
            icon: Icons.add_rounded,
            color: AppTheme.primary,
            onTap: () {
              HapticFeedback.lightImpact();
              cart.increaseQuantity(item.product.id);
            },
          ),
        ],
      ),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

//  Checkout Bar
class _CheckoutBar extends StatelessWidget {
  final CartController cart;
  const _CheckoutBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: AppTheme.divider)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Price breakdown
          _PriceRow(label: 'Subtotal', value: cart.formattedSubtotal),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Delivery',
            value: cart.formattedDelivery,
            valueColor: cart.deliveryCharge == 0
                ? AppTheme.success
                : AppTheme.textPrimary,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppTheme.divider, height: 1),
          ),
          _PriceRow(
            label: 'Total',
            value: cart.formattedTotal,
            isTotal: true,
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Proceed to Checkout',
            icon: Icons.lock_rounded,
            onTap: () => Get.snackbar(
              '🎉 Coming Soon',
              'Checkout feature will be available soon!',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.headingMedium
              : AppTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? AppTheme.priceLarge
              : AppTheme.bodyLarge.copyWith(
            color: valueColor ?? AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

//  Empty Cart
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.divider),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppTheme.textMuted, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Your cart is empty', style: AppTheme.headingMedium),
          const SizedBox(height: 10),
          Text('Add some amazing products!', style: AppTheme.bodyMedium),
          const SizedBox(height: 28),
          GradientButton(
            label: 'Continue Shopping',
            icon: Icons.arrow_back_rounded,
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}