import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// ✅ Initialize Notifications
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  /// ✅ Enable Notifications
  static void enableNotifications() {
    _showNotification("Notifications Enabled", "You will receive alerts for backups & security events.");
  }

  /// ✅ Disable Notifications
  static void disableNotifications() {
    _showNotification("Notifications Disabled", "You will no longer receive alerts.");
  }

  /// ✅ Show Notification
  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'secure_data_app',
      'App Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }
}
