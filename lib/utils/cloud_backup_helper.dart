import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';

class CloudBackupHelper {
  static const _scopes = [drive.DriveApi.driveFileScope];

  /// ✅ Authenticate & Get Google Drive API Client
  static Future<drive.DriveApi?> _getDriveApi() async {
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "your_project_id",
      "private_key_id": "your_private_key_id",
      "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
      "client_email": "your_service_account_email",
      "client_id": "your_client_id",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
    });

    final client = await clientViaServiceAccount(credentials, _scopes);
    return drive.DriveApi(client);
  }

  /// ✅ Upload File to Google Drive
  static Future<void> uploadBackup(File file) async {
    final api = await _getDriveApi();
    if (api == null) return;

    var driveFile = drive.File();
    driveFile.name = "SecureDataBackup-${DateTime.now().toIso8601String()}.json";

    await api.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );
  }

  /// ✅ Create Backup & Upload to Google Drive
  static Future<void> createBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File("${directory.path}/backup.json");

    await backupFile.writeAsString('{"data": "Your secure data"}');
    await uploadBackup(backupFile);
  }
}
