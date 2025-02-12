import 'package:flutter/material.dart';
import 'setup_complete_page.dart';

class FaceRecognitionSetupPage extends StatefulWidget {
  const FaceRecognitionSetupPage({super.key});

  @override
  State<FaceRecognitionSetupPage> createState() => _FaceRecognitionSetupPageState();
}

class _FaceRecognitionSetupPageState extends State<FaceRecognitionSetupPage> {
  Future<void> registerFace() async {
    // TODO: Implement real face recognition using ML Kit or an alternative library
    await Future.delayed(const Duration(seconds: 2)); // Simulating process

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SetupCompletePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Recognition Setup")),
      body: Center(
        child: ElevatedButton(
          onPressed: registerFace,
          child: const Text("Register Face"),
        ),
      ),
    );
  }
}
