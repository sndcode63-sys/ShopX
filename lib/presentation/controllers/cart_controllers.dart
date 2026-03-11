import 'package:get/get.dart';

import '../../data/models/cart models.dart';
import '../../data/models/product_model.dart';


class CartController extends GetxController {

  final _items = <CartItem>[].obs;

  //  Getters
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  String get formattedSubtotal => '₹${(subtotal * 83).toStringAsFixed(0)}';

  double get deliveryCharge => subtotal > 50 ? 0 : 4.99;
  String get formattedDelivery =>
      deliveryCharge == 0 ? 'FREE' : '₹${(deliveryCharge * 83).toStringAsFixed(0)}';

  double get grandTotal => subtotal + deliveryCharge;
  String get formattedTotal => '₹${(grandTotal * 83).toStringAsFixed(0)}';

  //  Cart Operations
  void addToCart(ProductModel product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);

    if (idx >= 0) {
      _items[idx].quantity++;
      _items.refresh();
      Get.snackbar(
        '✅ Updated',
        '${product.shortTitle} quantity updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      _items.add(CartItem(product: product));
      Get.snackbar(
        '🛍️ Added!',
        '${product.shortTitle} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void increaseQuantity(int productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      _items[idx].quantity++;
      _items.refresh();
    }
  }

  void decreaseQuantity(int productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (_items[idx].quantity <= 1) {
        removeFromCart(productId);
      } else {
        _items[idx].quantity--;
        _items.refresh();
      }
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
  }

  void clearCart() => _items.clear();

  bool isInCart(int productId) =>
      _items.any((i) => i.product.id == productId);

  int quantityOf(int productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }
}