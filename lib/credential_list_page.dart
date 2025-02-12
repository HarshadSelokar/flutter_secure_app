import 'package:flutter/material.dart';
import 'utils/database_helper.dart';

class CredentialListPage extends StatefulWidget {
  const CredentialListPage({super.key});

  @override
  _CredentialListPageState createState() => _CredentialListPageState();
}

class _CredentialListPageState extends State<CredentialListPage> {
  List<Map<String, dynamic>> _credentials = [];
  bool _isLoading = true;
  bool _obscurePasswords = true; // Toggle for password visibility

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  /// ✅ Load Credentials from Database
  Future<void> _loadCredentials() async {
    final credentials = await DatabaseHelper.getCredentials();
    setState(() {
      _credentials = credentials;
      _isLoading = false;
    });
  }

  /// ✅ Delete Credential with Animation
  Future<void> _deleteCredential(int id) async {
    setState(() {
      _credentials.removeWhere((cred) => cred['id'] == id);
    });
    await DatabaseHelper.deleteCredential(id);
  }

  /// ✅ Show Add Credential Dialog
  void _showAddCredentialDialog() {
    final titleController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Credential"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.insertCredential(
                titleController.text,
                usernameController.text,
                passwordController.text,
              );
              Navigator.pop(context);
              _loadCredentials();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Credentials"),
        actions: [
          IconButton(
            icon: Icon(_obscurePasswords ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscurePasswords = !_obscurePasswords; // Toggle password visibility
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _credentials.isEmpty
          ? const Center(child: Text("No credentials found."))
          : ListView.builder(
        itemCount: _credentials.length,
        itemBuilder: (context, index) {
          final credential = _credentials[index];
          return Dismissible(
            key: Key(credential["id"].toString()),
            background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
            onDismissed: (direction) => _deleteCredential(credential["id"]),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.blueAccent),
                title: Text(
                  credential["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username: ${credential["username"]}"),
                    Text("Password: ${_obscurePasswords ? "••••••••" : credential["password"]}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  onPressed: () {
                    _copyToClipboard(credential["password"]);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCredentialDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// ✅ Copy Password to Clipboard
  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password copied to clipboard")));
  }
}
