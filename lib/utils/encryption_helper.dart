import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionHelper {
  static const _storage = FlutterSecureStorage();
  static const String _keyStorageKey = "encryption_key";

  /// ✅ Generate & Store AES Key
  static Future<encrypt.Key> _getKey() async {
    String? storedKey = await _storage.read(key: _keyStorageKey);
    if (storedKey == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      await _storage.write(key: _keyStorageKey, value: base64Encode(key.bytes));
      return key;
    }
    return encrypt.Key(base64Decode(storedKey));
  }

  /// ✅ Encrypt Data
  static Future<String> encryptData(String plainText) async {
    final key = await _getKey();
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${base64Encode(iv.bytes)}:${encrypted.base64}";
  }

  /// ✅ Decrypt Data
  static Future<String> decryptData(String encryptedData) async {
    final key = await _getKey();
    final parts = encryptedData.split(":");
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedText = encrypt.Encrypted.fromBase64(parts[1]);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt(encryptedText, iv: iv);
  }
}
