import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;

  /// Verify the user's identity using Biometrics
  Future<void> authenticateUser() async {
    bool isAvailable = await auth.canCheckBiometrics;
    if (isAvailable) {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to reset password',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        isAuthenticated = authenticated;
      });

      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication failed!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric authentication not available")),
      );
    }
  }

  /// Save new password after authentication
  Future<void> saveNewPassword() async {
    if (isAuthenticated &&
        newPasswordController.text.isNotEmpty &&
        newPasswordController.text == confirmPasswordController.text) {
      await storage.write(key: 'user_password', value: newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successfully!")),
      );

      Navigator.pop(context); // Go back to login screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Authenticate using Biometrics to reset your password.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authenticateUser,
              child: const Text("Authenticate"),
            ),
            if (isAuthenticated) ...[
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: saveNewPassword,
                child: const Text("Save New Password"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
