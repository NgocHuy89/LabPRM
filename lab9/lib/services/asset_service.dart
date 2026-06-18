import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/item_model.dart';

class AssetService {
  static const String assetPath = 'assets/data/items.json';

  Future<List<Item>> loadItems() async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((e) => Item.fromJson(e)).toList();
  }
}
