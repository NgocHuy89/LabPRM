import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _loggingOut = true);
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: _loggingOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onPressed: _loggingOut ? null : _handleLogout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: (user.avatarUrl != null &&
                        user.avatarUrl!.isNotEmpty)
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 48)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.name.isNotEmpty ? user.name : 'Người dùng',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  user.provider == 'google'
                      ? 'Đăng nhập qua Google'
                      : 'Đăng nhập qua API',
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Phiên đăng nhập đã được lưu.\nĐóng app và mở lại sẽ tự động đăng nhập.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
