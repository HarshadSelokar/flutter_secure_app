import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'dashboard_page.dart';
import 'welcome_page.dart';
import 'onboarding_page.dart';
import 'authentication_page.dart';
import 'utils/notification_helper.dart';
import 'dart:async';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();

  /// ✅ Read stored values asynchronously
  String? isRegistered = await storage.read(key: 'is_registered');
  String? isDarkMode = await storage.read(key: 'is_dark_mode');
  String? seenOnboarding = await storage.read(key: 'seen_onboarding');

  /// ✅ Initialize notifications & schedule backup reminders
  await NotificationHelper.initialize();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode == 'true')),
      ],
      child: MyApp(
        isRegistered: isRegistered == 'true',
        seenOnboarding: seenOnboarding == 'true',
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isRegistered;
  final bool seenOnboarding;

  const MyApp({
    super.key,
    required this.isRegistered,
    required this.seenOnboarding,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _sessionTimer;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _resetSessionTimer();
  }

  /// ✅ Reset session timer when user interacts
  void _resetSessionTimer() async {
    String? timeout = await storage.read(key: 'session_timeout');
    int sessionTimeout = timeout != null ? int.parse(timeout) : 5; // Default: 5 minutes

    /// ✅ Cancel any existing timer before starting a new one
    _sessionTimer?.cancel();
    _sessionTimer = Timer(Duration(minutes: sessionTimeout), _lockApp);
  }

  /// ✅ Lock the app & navigate to Authentication Page
  void _lockApp() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationPage()),
      );
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel(); // ✅ Ensure timer is properly disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetSessionTimer,
      onPanDown: (_) => _resetSessionTimer(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secure Data App',
        theme: Provider.of<ThemeProvider>(context).isDarkMode
            ? ThemeData.dark()
            : ThemeData.light(),
        home: widget.seenOnboarding
            ? (widget.isRegistered ? const DashboardPage() : const WelcomePage())
            : const OnboardingPage(),
      ),
    );
  }
}

/// ✅ Theme Provider for Efficient State Management
class ThemeProvider with ChangeNotifier {
  bool isDarkMode;

  ThemeProvider(this.isDarkMode);

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
