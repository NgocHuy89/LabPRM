import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Cho phép inject http.Client từ ngoài (phục vụ unit test / mock)
  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Post.fromJson(item)).toList();
      } else {
        throw ApiException('Lỗi server: ${response.statusCode}');
      }
    } on FormatException {
      throw ApiException('Dữ liệu trả về không hợp lệ.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Đã có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({
              'title': title,
              'body': body,
              'userId': userId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Tạo bài viết thất bại: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Đã có lỗi xảy ra khi tạo bài viết.');
    }
  }

  void dispose() {
    client.close();
  }
}
