import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'face_recognition_setup_page.dart';

class FingerprintSetupPage extends StatefulWidget {
  const FingerprintSetupPage({super.key});

  @override
  State<FingerprintSetupPage> createState() => _FingerprintSetupPageState();
}

class _FingerprintSetupPageState extends State<FingerprintSetupPage> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> registerFingerprint() async {
    bool isAvailable = await auth.canCheckBiometrics;
    if (isAvailable) {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Register your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FaceRecognitionSetupPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fingerprint registration failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fingerprint not available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fingerprint Setup")),
      body: Center(
        child: ElevatedButton(
          onPressed: registerFingerprint,
          child: const Text("Register Fingerprint"),
        ),
      ),
    );
  }
}
