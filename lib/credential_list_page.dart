import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'credential_detail_page.dart';

class CredentialListPage extends StatefulWidget {
  const CredentialListPage({super.key});

  @override
  State<CredentialListPage> createState() => _CredentialListPageState();
}

class _CredentialListPageState extends State<CredentialListPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<Map<String, String>> credentials = [];
  List<Map<String, String>> filteredCredentials = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final allKeys = await secureStorage.readAll();
    List<Map<String, String>> loadedCredentials = [];

    allKeys.forEach((key, value) {
      loadedCredentials.add({
        'service': key,
        'username': value.split('|')[0],
        'password': value.split('|')[1],
      });
    });

    setState(() {
      credentials = loadedCredentials;
      filteredCredentials = loadedCredentials;
    });
  }

  void _searchCredentials(String query) {
    setState(() {
      filteredCredentials = credentials
          .where((cred) => cred['service']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Credentials")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _searchCredentials,
              decoration: const InputDecoration(
                labelText: "Search Credentials",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredCredentials.isEmpty
                ? const Center(child: Text("No credentials found."))
                : ListView.builder(
              itemCount: filteredCredentials.length,
              itemBuilder: (context, index) {
                final credential = filteredCredentials[index];
                return ListTile(
                  title: Text(credential['service']!),
                  subtitle: Text(credential['username']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CredentialDetailPage(
                          service: credential['service']!,
                          username: credential['username']!,
                          password: credential['password']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
