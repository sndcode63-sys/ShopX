import 'package:get/get.dart';
import '../../presentation/controllers/cart_controllers.dart';
import '../../presentation/controllers/product_controllers.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}