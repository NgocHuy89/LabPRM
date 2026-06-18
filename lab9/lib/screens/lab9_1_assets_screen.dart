import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/asset_service.dart';

class Lab91AssetsScreen extends StatefulWidget {
  const Lab91AssetsScreen({super.key});

  @override
  State<Lab91AssetsScreen> createState() => _Lab91AssetsScreenState();
}

class _Lab91AssetsScreenState extends State<Lab91AssetsScreen> {
  final AssetService _assetService = AssetService();
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _assetService.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9.1 - Read From Assets')),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi đọc JSON: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${item.id}')),
                title: Text(item.name),
                subtitle: Text(item.category),
                trailing: Text('\$${item.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
