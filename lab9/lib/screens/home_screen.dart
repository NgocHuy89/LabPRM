import 'package:flutter/material.dart';
import 'lab9_1_assets_screen.dart';
import 'lab9_2_storage_screen.dart';
import 'lab9_3_crud_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9 - JSON Storage')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            title: '9.1 - Read JSON From Assets',
            subtitle: 'Đọc danh sách menu từ file JSON đóng gói trong assets',
            icon: Icons.inventory_2_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Lab91AssetsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: '9.2 - Save & Load Local Storage',
            subtitle: 'Thêm món mới, lưu vào bộ nhớ thiết bị, tồn tại sau khi tắt app',
            icon: Icons.save_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Lab92StorageScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: '9.3 - CRUD Mini Database',
            subtitle: 'Thêm / Sửa / Xoá / Tìm kiếm, tự động lưu sau mỗi thay đổi',
            icon: Icons.storage_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Lab93CrudScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
