import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission3_restaurant_app/utils/background_service.dart';
import 'package:submission3_restaurant_app/utils/date_time_helper.dart';

class SettingProvider extends ChangeNotifier {
  static const String settingPrefs = "setting";
  bool _isReminderOn = false;

  bool get isReminderOn => _isReminderOn;

  SettingProvider() {
    _loadSettings();
  }

  void _saveSettings() async {
    final SharedPreferences settings = await SharedPreferences.getInstance();
    settings.setBool(settingPrefs, _isReminderOn);
    notifyListeners();
  }

  void _loadSettings() async {
    final setting = await SharedPreferences.getInstance();
    _isReminderOn = setting.getBool(settingPrefs) ?? false;
    notifyListeners();
  }

  Future<bool> scheduledNotification(bool value) async {
    _isReminderOn = value;
    _saveSettings();
    if (_isReminderOn) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
