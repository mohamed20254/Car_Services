import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// حالة الإشعارات
class NotificationState {
  final bool isNotificationEnabled;

  NotificationState(this.isNotificationEnabled);
}

// **Cubit** لإدارة حالة الإشعارات
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
    : super(NotificationState(true)); // افتراضياً، الإشعارات مفعلة.

  // تحميل حالة الإشعارات من SharedPreferences
  Future<void> loadNotificationSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('notifications_enabled') ?? true;
    emit(NotificationState(isEnabled));
  }

  // تغيير حالة الإشعارات
  Future<void> toggleNotification(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications_enabled', isEnabled);
    emit(NotificationState(isEnabled));
  }
}
