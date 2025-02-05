import 'package:flutter/material.dart';

class CredentialDetailPage extends StatefulWidget {
  final String service;
  final String username;
  final String password;

  const CredentialDetailPage({
    super.key,
    required this.service,
    required this.username,
    required this.password,
  });

  @override
  State<CredentialDetailPage> createState() => _CredentialDetailPageState();
}

class _CredentialDetailPageState extends State<CredentialDetailPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void saveChanges() {
    // Return the updated values to the previous page
    Navigator.pop(context, {
      'username': usernameController.text,
      'password': passwordController.text,
    });
  }

  void deleteCredential() {
    // Return a signal to delete the credential
    Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Edit Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text("Save Changes"),
            ),
            ElevatedButton(
              onPressed: deleteCredential,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete Credential"),
            ),
          ],
        ),
      ),
    );
  }
}
