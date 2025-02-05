import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'setup_complete_page.dart'; // Import the setup complete page

class FaceRecognitionSetupPage extends StatelessWidget {
  const FaceRecognitionSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    Future<void> completeSetup() async {
      // Mark the user as registered in secure storage
      await secureStorage.write(key: 'is_registered', value: 'true');

      // Navigate to the Setup Complete page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SetupCompletePage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Set Up Face Recognition")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Position your face in the camera to register",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: completeSetup,
              child: const Text("Complete Setup"),
            ),
          ],
        ),
      ),
    );
  }
}
