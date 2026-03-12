import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_x/presentation/controllers/theme_controller.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_bindings.dart';
import 'core/utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopX',
          theme: AppTheme.lightThemeData,
          darkTheme: AppTheme.darkThemeData,
          themeMode: themeCtrl.isDark ? ThemeMode.dark : ThemeMode.light,
          initialBinding: AppBindings(),
          initialRoute: AppConstants.splashRoute,
          getPages: AppRoutes.pages,
          defaultTransition: Transition.fadeIn,
          transitionDuration: AppConstants.animMedium,
        ));
  }
}
