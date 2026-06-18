import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';

class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});

  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}

class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  final StorageService _storageService = StorageService();
  List<Item> _items = [];
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _storageService.readItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  void _addItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final category = _categoryController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final newId = _items.isEmpty
        ? 1
        : _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    setState(() {
      _items.add(Item(
        id: newId,
        name: name,
        category: category.isEmpty ? 'Khác' : category,
        price: price,
      ));
    });

    _nameController.clear();
    _categoryController.clear();
    _priceController.clear();
  }

  Future<void> _saveItems() async {
    await _storageService.saveItems(_items);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu vào bộ nhớ thiết bị')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9.2 - Save & Load Storage')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên món',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Loại',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Giá',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm vào danh sách'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(child: Text('Chưa có dữ liệu'))
                      : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text('${item.id}')),
                              title: Text(item.name),
                              subtitle: Text(item.category),
                              trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveItems,
        tooltip: 'Lưu file JSON',
        child: const Icon(Icons.save),
      ),
    );
  }
}
