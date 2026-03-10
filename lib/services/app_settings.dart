import 'package:hive/hive.dart';

class AppSettings {
  static const boxName = 'settings_box';
  static const keyThemeIsDark = 'theme_is_dark';

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static bool isDark() {
    final box = Hive.box(boxName);
    return box.get(keyThemeIsDark, defaultValue: true) as bool;
  }

  static Future<void> setDark(bool value) async {
    final box = Hive.box(boxName);
    await box.put(keyThemeIsDark, value);
  }
}
