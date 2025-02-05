import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'face_recognition_setup_page.dart'; // Import the page for setting up face recognition

class FingerprintSetupPage extends StatelessWidget {
  const FingerprintSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalAuthentication auth = LocalAuthentication();

    Future<void> authenticate() async {
      try {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Register your fingerprint',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );

        if (authenticated) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FaceRecognitionSetupPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fingerprint registration failed. Try again.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Set Up Fingerprint")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Place your finger on the scanner to register",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: authenticate,
              child: const Text("Register Fingerprint"),
            ),
          ],
        ),
      ),
    );
  }
}
