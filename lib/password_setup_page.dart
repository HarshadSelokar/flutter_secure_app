import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'fingerprint_setup_page.dart';

class PasswordSetupPage extends StatefulWidget {
  const PasswordSetupPage({super.key});

  @override
  State<PasswordSetupPage> createState() => _PasswordSetupPageState();
}

class _PasswordSetupPageState extends State<PasswordSetupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> savePasswordAndProceed() async {
    if (passwordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text) {
      await storage.write(key: 'user_password', value: passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FingerprintSetupPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Your Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create a strong password for security.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Enter Password"),
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
              onPressed: savePasswordAndProceed,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
