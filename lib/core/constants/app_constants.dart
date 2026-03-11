class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';

  // Routes
  static const String splashRoute        = '/splash';
  static const String homeRoute          = '/home';
  static const String cartRoute          = '/cart';
  static const String productDetailRoute = '/product-detail';


  // Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 400);
  static const Duration animSlow = Duration(milliseconds: 600);

  // Spacing
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  // Border Radius
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 20;
  static const double radiusXL = 28;
  static const double radiusFull = 100;
}