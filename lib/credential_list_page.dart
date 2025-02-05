import 'package:flutter/material.dart';
import 'credential_detail_page.dart';

class CredentialListPage extends StatefulWidget {
  const CredentialListPage({super.key});

  @override
  State<CredentialListPage> createState() => _CredentialListPageState();
}

class _CredentialListPageState extends State<CredentialListPage> {
  List<Map<String, String>> credentials = [
    {'service': 'Gmail', 'username': 'user@gmail.com', 'password': '********'},
    {'service': 'Spotify', 'username': 'spotify_user', 'password': '********'},
  ];

  void handleEdit(int index, dynamic result) {
    if (result is Map<String, String>) {
      setState(() {
        credentials[index] = {
          'service': credentials[index]['service']!,
          'username': result['username']!,
          'password': result['password']!,
        };
      });
    } else if (result == 'deleted') {
      setState(() {
        credentials.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Credentials")),
      body: ListView.builder(
        itemCount: credentials.length,
        itemBuilder: (context, index) {
          final credential = credentials[index];
          return ListTile(
            title: Text(credential['service']!),
            subtitle: Text(credential['username']!),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CredentialDetailPage(
                    service: credential['service']!,
                    username: credential['username']!,
                    password: credential['password']!,
                  ),
                ),
              );
              handleEdit(index, result);
            },
          );
        },
      ),
    );
  }
}
