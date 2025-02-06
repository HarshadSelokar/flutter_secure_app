import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class BackupHelper {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  static const String backupFileName = "secure_backup.zip";

  /// Create a backup ZIP file containing encrypted files & credentials
  static Future<String> createBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFilePath = '${directory.path}/$backupFileName';

    // Get encrypted files
    List<File> encryptedFiles = await _getEncryptedFiles();

    // Get stored credentials
    Map<String, String> credentials = await secureStorage.readAll();

    // Create ZIP archive
    final archive = Archive();

    // Add encrypted files to archive
    for (File file in encryptedFiles) {
      final fileBytes = await file.readAsBytes();
      archive.addFile(ArchiveFile(file.uri.pathSegments.last, fileBytes.length, fileBytes));
    }

    // Add credentials as a JSON file inside ZIP
    final credentialsData = credentials.entries.map((e) => '${e.key}:${e.value}').join('\n');
    archive.addFile(ArchiveFile('credentials.txt', credentialsData.length, credentialsData.codeUnits));

    // Save ZIP file
    final zipFile = File(backupFilePath);
    await zipFile.writeAsBytes(ZipEncoder().encode(archive)!);

    return backupFilePath;
  }

  /// Restore encrypted files and credentials from a backup ZIP file
  static Future<void> restoreBackup(String backupPath) async {
    final backupFile = File(backupPath);

    if (!backupFile.existsSync()) {
      throw Exception("Backup file not found!");
    }

    // Read ZIP contents
    final bytes = await backupFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final directory = await getApplicationDocumentsDirectory();

    for (var file in archive) {
      if (file.isFile) {
        final filePath = '${directory.path}/${file.name}';
        await File(filePath).writeAsBytes(file.content as List<int>);

        if (file.name == 'credentials.txt') {
          // Restore credentials
          final credentialLines = String.fromCharCodes(file.content as List<int>).split('\n');
          for (var line in credentialLines) {
            final parts = line.split(':');
            if (parts.length == 2) {
              await secureStorage.write(key: parts[0], value: parts[1]);
            }
          }
        }
      }
    }
  }

  /// Get a list of all encrypted files
  static Future<List<File>> _getEncryptedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.listSync()
        .where((entity) => entity is File && entity.path.endsWith('.enc'))
        .map((entity) => entity as File)
        .toList();
  }
}
