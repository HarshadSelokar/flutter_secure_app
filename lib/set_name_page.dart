import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'password_setup_page.dart';

class SetNamePage extends StatefulWidget {
  const SetNamePage({super.key});

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  final TextEditingController nameController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveNameAndProceed() async {
    if (nameController.text.isNotEmpty) {
      await storage.write(key: 'user_name', value: nameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasswordSetupPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Your Name")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your name to personalize your experience.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: saveNameAndProceed,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
