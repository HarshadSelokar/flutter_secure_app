import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'utils/backup_helper.dart';
import 'credential_list_page.dart';
import 'file_import_page.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const DashboardPage({super.key, required this.toggleTheme});

  Future<void> createBackup(BuildContext context) async {
    try {
      String backupPath = await BackupHelper.createBackup();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Backup created at: $backupPath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Backup failed: ${e.toString()}")),
      );
    }
  }

  Future<void> restoreBackup(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      try {
        await BackupHelper.restoreBackup(result.files.single.path!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Backup restored successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Restore failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme, // ✅ Dark Mode Toggle
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to your secure dashboard!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CredentialListPage(),
                  ),
                );
              },
              child: const Text("Manage Credentials"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FileImportPage(),
                  ),
                );
              },
              child: const Text("Manage Files"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => createBackup(context),
              child: const Text("Create Backup"), // ✅ Ensure exact text for Flutter Test
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => restoreBackup(context),
              child: const Text("Restore Backup"), // ✅ Ensure exact text for Flutter Test
            ),
          ],
        ),
      ),
    );
  }
}
