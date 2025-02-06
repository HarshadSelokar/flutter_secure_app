import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    passwordController = TextEditingController(text: widget.password);
  }

  Future<void> saveChanges() async {
    await secureStorage.write(
      key: widget.service,
      value: '${usernameController.text}|${passwordController.text}',
    );
    Navigator.pop(context, 'updated');
  }

  Future<void> deleteCredential() async {
    await secureStorage.delete(key: widget.service);
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
            const Text("Edit Username", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: usernameController),
            const SizedBox(height: 20),
            const Text("Edit Password", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: passwordController, obscureText: true),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: saveChanges, child: const Text("Save Changes")),
            ElevatedButton(
              onPressed: deleteCredential,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete Credential"),
            ),
          ],
        ),
      ),
    );
  }
}
