import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard_page.dart';
import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();

  // Check if the user has completed the initial setup
  String? isRegistered = await storage.read(key: 'is_registered');
  String? isDarkMode = await storage.read(key: 'is_dark_mode');

  runApp(MyApp(isDarkMode: isDarkMode == 'true', isRegistered: isRegistered == 'true'));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final bool isRegistered;

  const MyApp({super.key, required this.isDarkMode, required this.isRegistered});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    final storage = FlutterSecureStorage();
    await storage.write(key: 'is_dark_mode', value: _isDarkMode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Data App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: widget.isRegistered
          ? DashboardPage(toggleTheme: toggleTheme)
          : WelcomePage(), // Redirect to Welcome Page for first-time users
    );
  }
}
