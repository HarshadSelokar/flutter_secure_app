import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme_provider.dart';
import '../utils/notification_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  int _autoLogoutTime = 5; // Default to 5 minutes

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// ✅ Load User Preferences
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _autoLogoutTime = prefs.getInt('autoLogoutTime') ?? 5;
    });
  }

  /// ✅ Save Preferences
  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setInt('autoLogoutTime', _autoLogoutTime);
  }

  /// ✅ Toggle Dark Mode
  void _toggleTheme() {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  /// ✅ Change Auto-Logout Timer
  void _changeAutoLogoutTime(int time) {
    setState(() {
      _autoLogoutTime = time;
    });
    _savePreferences();
  }

  /// ✅ Toggle Notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _savePreferences();
    if (_notificationsEnabled) {
      NotificationHelper.enableNotifications();
    } else {
      NotificationHelper.disableNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// ✅ Theme Toggle
            ListTile(
              leading: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => _toggleTheme(),
              ),
            ).animate().fade(duration: 500.ms),

            /// ✅ Auto-Logout Timer
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text("Auto-Logout Time"),
              trailing: DropdownButton<int>(
                value: _autoLogoutTime,
                items: [5, 10, 15]
                    .map((time) => DropdownMenuItem<int>(
                  value: time,
                  child: Text("$time min"),
                ))
                    .toList(),
                onChanged: (value) => _changeAutoLogoutTime(value!),
              ),
            ).animate().fade(duration: 600.ms),

            /// ✅ Notifications Toggle
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Enable Notifications"),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ).animate().fade(duration: 700.ms),

            const SizedBox(height: 20),

            /// ✅ Reset Preferences Button
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                _loadPreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Preferences Reset!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Reset Preferences"),
            ).animate().fade(duration: 800.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }
}
