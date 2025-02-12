import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileImportPage extends StatefulWidget {
  const FileImportPage({super.key});

  @override
  State<FileImportPage> createState() => _FileImportPageState();
}

class _FileImportPageState extends State<FileImportPage> {
  List<String> files = [];

  Future<void> pickAndSaveFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      Directory appDir = await getApplicationDocumentsDirectory();
      String newPath = '${appDir.path}/${result.files.single.name}';
      await selectedFile.copy(newPath);

      setState(() {
        files.add(newPath);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved to app storage: ${result.files.single.name}")),
      );
    }
  }

  Future<void> deleteFile(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      setState(() {
        files.remove(filePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Files")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickAndSaveFile,
            child: const Text("Import File"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index].split('/').last),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteFile(files[index]),
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
