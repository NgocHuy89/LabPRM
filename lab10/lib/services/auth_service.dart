import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const String _baseUrl = 'https://dummyjson.com';
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // ---------------- Lab 10.2: Real REST API Login ----------------
  Future<AppUser> loginWithApi({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    late http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw AuthException('Không thể kết nối tới máy chủ. Vui lòng thử lại.');
    }

    if (response.statusCode != 200) {
      String message = 'Đăng nhập thất bại';
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? message;
      } catch (_) {}
      throw AuthException(message);
    }

    final data = jsonDecode(response.body);
    final token = data['accessToken'] ?? data['token'];
    if (token == null) {
      throw AuthException('Không nhận được token từ máy chủ.');
    }

    final user = AppUser(
      id: data['id'].toString(),
      name: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
      email: data['email'] ?? '',
      avatarUrl: data['image'],
      provider: 'api',
    );

    // ---------------- Lab 10.3: persist session ----------------
    await _saveSession(token: token, user: user);
    return user;
  }

  // ---------------- Lab 10.4: Firebase Google Sign-In ----------------
  Future<AppUser> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Đăng nhập Google đã bị hủy.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await fb.FirebaseAuth.instance.signInWithCredential(credential);
      final fbUser = userCredential.user;

      if (fbUser == null) {
        throw AuthException('Đăng nhập Google thất bại.');
      }

      final user = AppUser(
        id: fbUser.uid,
        name: fbUser.displayName ?? 'Google User',
        email: fbUser.email ?? '',
        avatarUrl: fbUser.photoURL,
        provider: 'google',
      );

      // Firebase ID token used as the persisted session token
      final idToken = await fbUser.getIdToken() ?? 'firebase_session';
      await _saveSession(token: idToken, user: user);
      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Lỗi đăng nhập Google: $e');
    }
  }

  // ---------------- Lab 10.3: Auto-login / session ----------------
  Future<void> _saveSession({
    required String token,
    required AppUser user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<bool> hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  Future<AppUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw == null) return null;
    return AppUser.fromJson(jsonDecode(raw));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);

    // Sign out from both providers regardless of which one was used
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await fb.FirebaseAuth.instance.signOut();
    } catch (_) {}
  }
}
