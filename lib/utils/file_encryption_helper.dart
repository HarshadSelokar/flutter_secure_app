import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class FileEncryptionHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _keyStorageKey = "encryption_key";

  /// Generate and store encryption key securely
  static Future<encrypt.Key> _getEncryptionKey() async {
    String? storedKey = await _secureStorage.read(key: _keyStorageKey);

    if (storedKey == null) {
      final key = encrypt.Key.fromSecureRandom(32); // 256-bit AES key
      await _secureStorage.write(key: _keyStorageKey, value: key.base64);
      return key;
    }

    return encrypt.Key.fromBase64(storedKey);
  }

  /// Encrypt a file and save it securely
  static Future<String> encryptFile(File file) async {
    final key = await _getEncryptionKey();
    final iv = encrypt.IV.fromLength(16); // Random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    Uint8List fileBytes = await file.readAsBytes();
    final encryptedData = encrypter.encryptBytes(fileBytes, iv: iv);

    final directory = await getApplicationDocumentsDirectory();
    final encryptedFilePath = '${directory.path}/${file.uri.pathSegments.last}.enc';

    File encryptedFile = File(encryptedFilePath);
    await encryptedFile.writeAsBytes(iv.bytes + encryptedData.bytes);

    return encryptedFilePath;
  }

  /// Decrypt a file and return its original content
  static Future<File> decryptFile(String encryptedFilePath) async {
    final key = await _getEncryptionKey();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    File encryptedFile = File(encryptedFilePath);
    Uint8List encryptedBytes = await encryptedFile.readAsBytes();

    final iv = encrypt.IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));
    final encryptedData = encrypt.Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));

    final decryptedBytes = encrypter.decryptBytes(encryptedData, iv: iv);

    final directory = await getApplicationDocumentsDirectory();
    final decryptedFilePath = '${directory.path}/decrypted_${encryptedFile.uri.pathSegments.last.replaceAll(".enc", "")}';

    File decryptedFile = File(decryptedFilePath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    return decryptedFile;
  }

  /// Delete an encrypted file
  static Future<void> deleteEncryptedFile(String encryptedFilePath) async {
    File file = File(encryptedFilePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
