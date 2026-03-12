import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/theme/app_theme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _box = GetStorage();
  static const _key = 'isDark';

  final _isDark = true.obs;

  bool get isDark => _isDark.value;
  AppThemeData get theme => isDark ? AppTheme.dark : AppTheme.light;

  @override
  void onInit() {
    super.onInit();
    _isDark.value = _box.read<bool>(_key) ?? true;
  }

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    _box.write(_key, _isDark.value);
    Get.changeTheme(isDark ? AppTheme.darkThemeData : AppTheme.lightThemeData);
  }

  void setDark() => _set(true);
  void setLight() => _set(false);

  void _set(bool dark) {
    if (_isDark.value == dark) return;
    _isDark.value = dark;
    _box.write(_key, dark);
    Get.changeTheme(dark ? AppTheme.darkThemeData : AppTheme.lightThemeData);
  }
}
