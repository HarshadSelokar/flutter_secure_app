import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode;

  ThemeProvider(this.isDarkMode);

  /// ✅ Toggle Dark Mode
  void toggleTheme() async {
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    notifyListeners();
  }
}
