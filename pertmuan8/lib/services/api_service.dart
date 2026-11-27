import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pemmob_tugas8/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // 3 digit terakhir NIM 265 -> angka tengah digeser ke belakang -> N = 256
  static const int nimN = 256;
  static const int nimUserId = 1499 + nimN; // 1755

  static const String fileName = 'users_265.json';
  static const String storageKey = 'users_storage_265';

  static int _toIntId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Future<io.File?> _localFile() async {
    if (kIsWeb) return null;
    final dir = await getApplicationDocumentsDirectory();
    return io.File('${dir.path}/$fileName');
  }

  static List<Map<String, dynamic>>? _parseUserList(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<List<Map<String, dynamic>>> _loadRawUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final fromPrefs = _parseUserList(prefs.getString(storageKey));
    if (fromPrefs != null && fromPrefs.isNotEmpty) {
      return fromPrefs;
    }

    final file = await _localFile();
    if (file != null && await file.exists()) {
      final content = await file.readAsString();
      final fromFile = _parseUserList(content);
      if (fromFile != null && fromFile.isNotEmpty) {
        await prefs.setString(storageKey, jsonEncode(fromFile));
        return fromFile;
      }
    }

    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      final mapped = data
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      await _saveRawUsers(mapped);
      return mapped;
    }

    throw Exception('Gagal mengambil data users (${response.statusCode})');
  }

  static Future<void> _saveRawUsers(List<Map<String, dynamic>> users) async {
    final encoded = jsonEncode(users);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, encoded);

    final file = await _localFile();
    if (file != null) {
      await file.writeAsString(encoded);
    }
  }

  static Future<List<User>> getUsers() async {
    final rawList = await _loadRawUsers();
    return rawList.map((json) => User.fromJson(json)).toList();
  }

  static Future<User> getUser(int id) async {
    final users = await getUsers();
    return users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('User dengan ID $id tidak ditemukan'),
    );
  }

  static Future<User> createUser({
    required String name,
    required String email,
    required String city,
  }) async {
    final rawList = await _loadRawUsers();
    int nextId = nimUserId; // 1755
    for (final item in rawList) {
      final existingId = _toIntId(item['id']);
      if (existingId >= nextId) {
        nextId = existingId + 1;
      }
    }

    final payload = <String, dynamic>{
      'id': nextId,
      'name': name.trim(),
      'email': email.trim(),
      'city': city.trim(),
      'address': {'city': city.trim()},
    };

    try {
      await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(payload),
      );
    } catch (_) {}

    rawList.insert(0, payload);
    await _saveRawUsers(rawList);
    return User.fromJson(payload);
  }

  static Future<User> updateUserPut({
    required int id,
    required String name,
    required String email,
    required String city,
  }) async {
    final rawList = await _loadRawUsers();
    final index = rawList.indexWhere((item) => _toIntId(item['id']) == id);
    if (index == -1) {
      throw Exception('User dengan ID $id tidak ditemukan');
    }

    final updated = <String, dynamic>{
      ...rawList[index],
      'id': id,
      'name': name.trim(),
      'email': email.trim(),
      'city': city.trim(),
      'address': {'city': city.trim()},
    };

    try {
      await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(updated),
      );
    } catch (_) {}

    rawList[index] = updated;
    await _saveRawUsers(rawList);
    return User.fromJson(updated);
  }

  static Future<User> updateUserPatch(int id) async {
    final rawList = await _loadRawUsers();
    final index = rawList.indexWhere((item) => _toIntId(item['id']) == id);
    if (index == -1) {
      throw Exception('User dengan ID $id tidak ditemukan');
    }

    final currentName = rawList[index]['name']?.toString() ?? '';
    const suffix = ' - Flutter Developer';
    final patchedName = currentName.endsWith(suffix)
        ? currentName
        : '$currentName$suffix';

    final patched = <String, dynamic>{
      ...rawList[index],
      'name': patchedName,
    };

    try {
      await http.patch(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'name': patchedName}),
      );
    } catch (_) {}

    rawList[index] = patched;
    await _saveRawUsers(rawList);
    return User.fromJson(patched);
  }

  static Future<void> deleteUser(int id) async {
    final rawList = await _loadRawUsers();
    rawList.removeWhere((item) => _toIntId(item['id']) == id);

    try {
      await http.delete(Uri.parse('$baseUrl/users/$id'));
    } catch (_) {}

    await _saveRawUsers(rawList);
  }
}
