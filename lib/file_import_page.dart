import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'utils/file_encryption_helper.dart';

class FileImportPage extends StatefulWidget {
  const FileImportPage({super.key});

  @override
  State<FileImportPage> createState() => _FileImportPageState();
}

class _FileImportPageState extends State<FileImportPage> {
  List<String> encryptedFiles = [];

  Future<void> pickAndEncryptFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      String encryptedPath = await FileEncryptionHelper.encryptFile(selectedFile);

      setState(() {
        encryptedFiles.add(encryptedPath);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File encrypted and stored: ${result.files.single.name}")),
      );
    }
  }

  Future<void> decryptFile(String encryptedPath) async {
    File decryptedFile = await FileEncryptionHelper.decryptFile(encryptedPath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File decrypted: ${decryptedFile.path}")),
    );
  }

  Future<void> deleteFile(String encryptedPath) async {
    await FileEncryptionHelper.deleteEncryptedFile(encryptedPath);
    setState(() {
      encryptedFiles.remove(encryptedPath);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Encrypted file deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Encrypted Files")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickAndEncryptFile,
            child: const Text("Pick & Encrypt File"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: encryptedFiles.length,
              itemBuilder: (context, index) {
                String filePath = encryptedFiles[index];
                return ListTile(
                  title: Text(filePath.split('/').last),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => decryptFile(filePath),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteFile(filePath),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
