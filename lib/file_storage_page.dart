import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

class FileStoragePage extends StatefulWidget {
  const FileStoragePage({super.key});

  @override
  _FileStoragePageState createState() => _FileStoragePageState();
}

class _FileStoragePageState extends State<FileStoragePage> {
  List<File> _storedFiles = [];
  bool _isLoading = true;
  bool _isGridView = true; // Toggle between Grid & List View
  String _sortOption = "Date"; // Sorting preference

  @override
  void initState() {
    super.initState();
    _loadStoredFiles();
  }

  /// ✅ Load stored files from app storage
  Future<void> _loadStoredFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();
    setState(() {
      _storedFiles = files.whereType<File>().toList();
      _sortFiles();
      _isLoading = false;
    });
  }

  /// ✅ Pick and Store File
  Future<void> _pickAndStoreFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File pickedFile = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      String newFilePath = "${directory.path}/${pickedFile.uri.pathSegments.last}";
      File storedFile = await pickedFile.copy(newFilePath);

      setState(() {
        _storedFiles.add(storedFile);
        _sortFiles();
      });
    }
  }

  /// ✅ Sort Files
  void _sortFiles() {
    setState(() {
      if (_sortOption == "Name") {
        _storedFiles.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      } else if (_sortOption == "Date") {
        _storedFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      } else if (_sortOption == "Type") {
        _storedFiles.sort((a, b) {
          String extA = a.path.split('.').last;
          String extB = b.path.split('.').last;
          return extA.compareTo(extB);
        });
      }
    });
  }

  /// ✅ Open File
  void _openFile(File file) {
    OpenFile.open(file.path);
  }

  /// ✅ Delete File
  Future<void> _deleteFile(File file) async {
    await file.delete();
    setState(() {
      _storedFiles.remove(file);
    });
  }

  /// ✅ Detect File Type (Image, PDF, Video, Other)
  IconData _getFileIcon(String path) {
    final mimeType = lookupMimeType(path);

    if (mimeType != null) {
      if (mimeType.startsWith("image/")) return Icons.image;
      if (mimeType.startsWith("video/")) return Icons.video_library;
      if (mimeType == "application/pdf") return Icons.picture_as_pdf;
    }
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Storage"),
        actions: [
          /// ✅ Toggle Grid/List View
          IconButton(
            icon: Icon(_isGridView ? Icons.grid_on : Icons.list),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ).animate().fade(duration: 400.ms),

          /// ✅ Sort Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortOption = value;
                _sortFiles();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Name", child: Text("Sort by Name")),
              const PopupMenuItem(value: "Date", child: Text("Sort by Date")),
              const PopupMenuItem(value: "Type", child: Text("Sort by Type")),
            ],
          ).animate().fade(duration: 500.ms),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _storedFiles.isEmpty
          ? const Center(child: Text("No files stored."))
          : _isGridView
          ? _buildGridView()
          : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndStoreFile,
        child: const Icon(Icons.add),
      ).animate().scale(duration: 400.ms),
    );
  }

  /// ✅ Grid View for Files
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _storedFiles.length,
      itemBuilder: (context, index) {
        return _buildFileCard(_storedFiles[index]);
      },
    ).animate().fade(duration: 600.ms);
  }

  /// ✅ List View for Files
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _storedFiles.length,
      itemBuilder: (context, index) {
        return _buildFileTile(_storedFiles[index]);
      },
    ).animate().fade(duration: 600.ms);
  }

  /// ✅ Grid Card UI
  Widget _buildFileCard(File file) {
    String fileName = file.uri.pathSegments.last;

    return GestureDetector(
      onTap: () => _openFile(file),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getFileIcon(file.path), size: 50, color: Colors.blueAccent)
                .animate()
                .scale(duration: 500.ms),
            const SizedBox(height: 10),
            Text(
              fileName.length > 15 ? "${fileName.substring(0, 15)}..." : fileName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ).animate().fade(duration: 600.ms),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteFile(file),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ List Tile UI
  Widget _buildFileTile(File file) {
    String fileName = file.uri.pathSegments.last;

    return ListTile(
      leading: Icon(_getFileIcon(file.path), size: 40, color: Colors.blueAccent),
      title: Text(fileName),
      subtitle: Text("Last modified: ${file.lastModifiedSync()}"),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteFile(file),
      ),
      onTap: () => _openFile(file),
    );
  }
}
