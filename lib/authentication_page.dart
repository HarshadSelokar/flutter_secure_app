import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_data_app/dashboard_page.dart';
import 'utils/biometric_auth.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticating = false;
  bool _passwordChecked = false;
  bool _fingerprintChecked = false;
  bool _faceChecked = false;
  bool _showError = false;
  TextEditingController _passwordController = TextEditingController();
  AnimationController? _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  /// ✅ Check if user-entered password is correct
  void _checkPassword() {
    if (_passwordController.text == "Secure1234") { // Replace with actual stored password
      setState(() => _passwordChecked = true);
      _checkAuthentication();
    } else {
      setState(() => _showError = true);
      _shakeController!.forward(from: 0); // Trigger shake animation
    }
  }

  /// ✅ Try Fingerprint Authentication
  Future<void> _authenticateFingerprint() async {
    bool authenticated = await BiometricAuth.authenticate();
    if (authenticated) {
      setState(() => _fingerprintChecked = true);
      _checkAuthentication();
    } else {
      _showErrorDialog("Fingerprint Authentication Failed! Retry.");
    }
  }

  /// ✅ Try Face ID Authentication
  Future<void> _authenticateFace() async {
    bool authenticated = await BiometricAuth.authenticate();
    if (authenticated) {
      setState(() => _faceChecked = true);
      _checkAuthentication();
    } else {
      _showErrorDialog("Face Authentication Failed! Retry.");
    }
  }

  /// ✅ Check if all security steps are passed
  void _checkAuthentication() {
    if (_passwordChecked && _fingerprintChecked && _faceChecked) {
      _navigateToDashboard();
    }
  }

  /// ✅ Navigate to Dashboard
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  /// ✅ Show Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Fade-in App Title
            const Text(
              "Secure Data App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).animate().fade(duration: 500.ms),

            const SizedBox(height: 20),

            /// ✅ Password Check with Shake Animation on Error
            if (!_passwordChecked) ...[
              SizedBox(
                width: 250,
                child: AnimatedBuilder(
                  animation: _shakeController!,
                  builder: (context, child) {
                    double offset = 0;
                    if (_showError) {
                      offset = _shakeController!.value * 8;
                    }
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter 10-digit Password",
                      border: OutlineInputBorder(),
                      errorText: _showError ? "Incorrect Password" : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() => _showError = false);
                  _checkPassword();
                },
                child: const Text("Verify Password"),
              ),
            ].animate().fade(duration: 600.ms),

            /// ✅ Fingerprint Check with Scale Animation
            if (!_fingerprintChecked && _passwordChecked) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticateFingerprint,
                child: const Text("Use Fingerprint"),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOut),
            ],

            /// ✅ Face ID Check with Bounce Animation
            if (!_faceChecked && _fingerprintChecked) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticateFace,
                child: const Text("Use Face ID"),
              ).animate().moveY(begin: 50, end: 0, duration: 600.ms, curve: Curves.bounceOut),
            ],

            /// ✅ Loading Indicator on Authentication
            if (_isAuthenticating)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ).animate().fade(duration: 700.ms),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController?.dispose();
    super.dispose();
  }
}
