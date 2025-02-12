import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = "secure_data.db";
  static const String _tableCredentials = "credentials";
  static const String _tableFiles = "files";
  static const _storage = FlutterSecureStorage();

  /// ✅ Open or Initialize Database
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final String path = join(await getDatabasesPath(), _dbName);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableCredentials (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $_tableFiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT NOT NULL,
            filepath TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  /// ✅ Insert Credential (With Encryption)
  static Future<int> insertCredential(String title, String username, String password) async {
    final db = await getDatabase();
    String encryptedPassword = _encryptPassword(password);

    return await db.insert(
      _tableCredentials,
      {
        'title': title,
        'username': username,
        'password': encryptedPassword,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ✅ Retrieve Credentials
  static Future<List<Map<String, dynamic>>> getCredentials() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> credentials = await db.query(_tableCredentials);

    for (var credential in credentials) {
      credential['password'] = _decryptPassword(credential['password']);
    }

    return credentials;
  }

  /// ✅ Delete Credential
  static Future<int> deleteCredential(int id) async {
    final db = await getDatabase();
    return await db.delete(_tableCredentials, where: "id = ?", whereArgs: [id]);
  }

  /// ✅ Insert File Record
  static Future<int> insertFile(String filename, String filepath) async {
    final db = await getDatabase();
    return await db.insert(
      _tableFiles,
      {
        'filename': filename,
        'filepath': filepath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ✅ Retrieve Stored Files
  static Future<List<Map<String, dynamic>>> getStoredFiles() async {
    final db = await getDatabase();
    return await db.query(_tableFiles);
  }

  /// ✅ Delete File Record
  static Future<int> deleteFile(int id) async {
    final db = await getDatabase();
    return await db.delete(_tableFiles, where: "id = ?", whereArgs: [id]);
  }

  /// ✅ Encrypt Password Before Storing
  static String _encryptPassword(String password) {
    var key = utf8.encode("secure_key_12345"); // Should be stored securely
    var bytes = utf8.encode(password);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256 encryption
    return base64.encode(hmacSha256.convert(bytes).bytes);
  }

  /// ✅ Decrypt Password (Placeholder, since hashing is one-way)
  static String _decryptPassword(String hashedPassword) {
    return "[PROTECTED]"; // Since hashing is irreversible, return masked text
  }

  /// ✅ Clear All Data
  static Future<void> clearDatabase() async {
    final db = await getDatabase();
    await db.delete(_tableCredentials);
    await db.delete(_tableFiles);
  }
}
