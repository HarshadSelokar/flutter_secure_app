import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackupHelper {
  static const _storage = FlutterSecureStorage();
  static const String _backupFileName = "secure_backup.dat";

  /// ✅ Create a Backup of User Data
  static Future<String?> createBackup(String data) async {
    try {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final String backupPath = "${directory.path}/$_backupFileName";
      final File backupFile = File(backupPath);

      await backupFile.writeAsString(data);
      await _storage.write(key: "last_backup", value: backupPath);

      return backupPath;
    } catch (e) {
      print("❌ Error Creating Backup: $e");
      return null;
    }
  }

  /// ✅ Restore Backup Data
  static Future<String?> restoreBackup() async {
    try {
      String? backupPath = await _storage.read(key: "last_backup");
      if (backupPath == null) return null;

      final File backupFile = File(backupPath);
      if (!backupFile.existsSync()) return null;

      return await backupFile.readAsString();
    } catch (e) {
      print("❌ Error Restoring Backup: $e");
      return null;
    }
  }

  /// ✅ Delete Backup File
  static Future<bool> deleteBackup() async {
    try {
      String? backupPath = await _storage.read(key: "last_backup");
      if (backupPath == null) return false;

      final File backupFile = File(backupPath);
      if (backupFile.existsSync()) {
        await backupFile.delete();
        await _storage.delete(key: "last_backup");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error Deleting Backup: $e");
      return false;
    }
  }
}
