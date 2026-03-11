import 'package:shop_x/data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  String get formattedTotal => '₹${(totalPrice * 83).toStringAsFixed(0)}';
}