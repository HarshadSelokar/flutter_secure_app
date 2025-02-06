import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();

  // Read theme preference
  String? isDarkMode = await storage.read(key: 'is_dark_mode');
  runApp(MyApp(isDarkMode: isDarkMode == 'true'));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

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
      home: DashboardPage(toggleTheme: toggleTheme), // ✅ FIXED
    );
  }
}
