import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  final StorageService _storageService = StorageService();
  final _searchController = TextEditingController();

  List<Item> _items = [];
  List<Item> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadItems() async {
    final items = await _storageService.readItems();
    setState(() {
      _items = items;
      _filteredItems = items;
      _isLoading = false;
    });
  }

  List<Item> _filterItems(String keyword) {
    if (keyword.isEmpty) return List.of(_items);
    final lower = keyword.toLowerCase();
    return _items
        .where((item) =>
            item.name.toLowerCase().contains(lower) ||
            item.category.toLowerCase().contains(lower))
        .toList();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredItems = _filterItems(_searchController.text.trim());
    });
  }

  Future<void> _persist() async {
    await _storageService.saveItems(_items);
  }

  Future<void> _showItemDialog({Item? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? '');
    final priceController = TextEditingController(
      text: existing != null ? existing.price.toString() : '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Thêm món mới' : 'Sửa món'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Loại'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (saved != true) return;

    final name = nameController.text.trim();
    if (name.isEmpty) return;

    final category = categoryController.text.trim().isEmpty
        ? 'Khác'
        : categoryController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0;

    setState(() {
      if (existing == null) {
        final newId = _items.isEmpty
            ? 1
            : _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
        _items.add(Item(id: newId, name: name, category: category, price: price));
      } else {
        existing.name = name;
        existing.category = category;
        existing.price = price;
      }
      _filteredItems = _filterItems(_searchController.text.trim());
    });

    await _persist();
  }

  Future<void> _deleteItem(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Xoá "${item.name}" khỏi danh sách?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _items.removeWhere((e) => e.id == item.id);
      _filteredItems = _filterItems(_searchController.text.trim());
    });

    await _persist();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá "${item.name}"')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9.3 - CRUD + Search')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Tìm theo tên hoặc loại',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredItems.isEmpty
                      ? const Center(child: Text('Không tìm thấy món nào'))
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text('${item.id}')),
                              title: Text(item.name),
                              subtitle: Text(
                                '${item.category} • \$${item.price.toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showItemDialog(existing: item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteItem(item),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        tooltip: 'Thêm món mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}
