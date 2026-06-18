import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/item_model.dart';

class StorageService {
  static const String fileName = 'items.json';
  static const String seedAssetPath = 'assets/data/items.json';

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  /// Đọc danh sách item từ file trong bộ nhớ thiết bị.
  /// Nếu file chưa tồn tại (lần chạy đầu tiên), copy dữ liệu mẫu từ assets vào.
  Future<List<Item>> readItems() async {
    final file = await _getLocalFile();

    if (!await file.exists()) {
      final seedJson = await rootBundle.loadString(seedAssetPath);
      await file.writeAsString(seedJson);
      final List<dynamic> data = jsonDecode(seedJson);
      return data.map((e) => Item.fromJson(e)).toList();
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) return [];

    final List<dynamic> data = jsonDecode(content);
    return data.map((e) => Item.fromJson(e)).toList();
  }

  /// Ghi toàn bộ danh sách item xuống file JSON, overwrite nội dung cũ.
  Future<void> saveItems(List<Item> items) async {
    final file = await _getLocalFile();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
