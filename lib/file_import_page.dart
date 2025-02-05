import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileImportPage extends StatelessWidget {
  const FileImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Handle the file
        String filePath = result.files.single.path!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File imported: $filePath")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected.")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Import Files")),
      body: Center(
        child: ElevatedButton(
          onPressed: pickFile,
          child: const Text("Pick a File"),
        ),
      ),
    );
  }
}
