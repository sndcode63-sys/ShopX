
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../presentation/screens/cart/cart.dart';
import '../../presentation/screens/home.dart';
import '../../presentation/screens/product_details_screen.dart';
import '../../presentation/screens/splash.dart';




import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../presentation/screens/cart/cart.dart';
import '../../presentation/screens/home.dart';
import '../../presentation/screens/product_details_screen.dart';
import '../../presentation/screens/splash.dart';

class AppRoutes {
  AppRoutes._();

  static final pages = [
    GetPage(
      name: AppConstants.splashRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppConstants.cartRoute,
      page: () => const CartScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: AppConstants.animMedium,
    ),

    // ✅ FIX: preventDuplicates: false rakho
    // Jab same product pe dobara tap karo toh route block na ho
    // maintainState: true — screen pop hone ke baad state preserve rahegi
    GetPage(
      name: AppConstants.productDetailRoute,
      page: () => const ProductDetailScreen(),
      transition: Transition.downToUp,
      transitionDuration: AppConstants.animMedium,
      preventDuplicates: false,
      maintainState: true,
    ),
  ];
}