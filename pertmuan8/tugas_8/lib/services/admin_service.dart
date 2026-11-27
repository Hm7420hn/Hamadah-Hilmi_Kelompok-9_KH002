import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pemmob_tugas8/models/admin.dart';
import 'package:pemmob_tugas8/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  // ID Admin = 792 + N -> 792 + 256 = 1048
  static const int nimAdminId = 792 + ApiService.nimN;

  static const String fileName = 'admins_265.json';
  static const String storageKey = 'admins_storage_265';

  static int _toIntId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Future<io.File?> _localFile() async {
    if (kIsWeb) return null;
    final dir = await getApplicationDocumentsDirectory();
    return io.File('${dir.path}/$fileName');
  }

  static List<Map<String, dynamic>> _seedAdmins() {
    return [
      {
        'id': nimAdminId, // 1048
        'name': 'Admin Utama 265',
        'email': 'admin265@kampus.ac.id',
        'department': 'Network & Security',
      },
      {
        'id': nimAdminId + 1, // 1049
        'name': 'Bima Saputra',
        'email': 'bima.admin@kampus.ac.id',
        'department': 'Database Administration',
      },
      {
        'id': nimAdminId + 2, // 1050
        'name': 'Citra Lestari',
        'email': 'citra.admin@kampus.ac.id',
        'department': 'System Infrastructure',
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> _loadRawAdmins() async {
    final prefs = await SharedPreferences.getInstance();
    final rawPrefs = prefs.getString(storageKey);
    if (rawPrefs != null && rawPrefs.trim().isNotEmpty) {
      final decoded = jsonDecode(rawPrefs);
      if (decoded is List) {
        return decoded
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    }

    final file = await _localFile();
    if (file != null && await file.exists()) {
      final rawFile = await file.readAsString();
      if (rawFile.trim().isNotEmpty) {
        final decoded = jsonDecode(rawFile);
        if (decoded is List) {
          final parsed = decoded
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          await prefs.setString(storageKey, jsonEncode(parsed));
          return parsed;
        }
      }
    }

    final seeded = _seedAdmins();
    await _saveRawAdmins(seeded);
    return seeded;
  }

  static Future<void> _saveRawAdmins(List<Map<String, dynamic>> admins) async {
    final encoded = jsonEncode(admins);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, encoded);

    final file = await _localFile();
    if (file != null) {
      await file.writeAsString(encoded);
    }
  }

  static Future<List<Admin>> getAdmins() async {
    final rawList = await _loadRawAdmins();
    return rawList.map((json) => Admin.fromJson(json)).toList();
  }

  static Future<Admin> getAdmin(int id) async {
    final admins = await getAdmins();
    return admins.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Admin dengan ID $id tidak ditemukan'),
    );
  }

  static Future<void> deleteAdmin(int id) async {
    final rawList = await _loadRawAdmins();
    final index = rawList.indexWhere((item) => _toIntId(item['id']) == id);
    if (index != -1) {
      rawList.removeAt(index);
      await _saveRawAdmins(rawList);
    }
  }
}
