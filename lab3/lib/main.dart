import 'dart:async';
import 'dart:convert';


// ============================================================
//  LAB 3 – Advanced Dart Practice Exercises
//  Tất cả 5 bài tập được gộp trong một file duy nhất.
//  Chạy trực tiếp trên DartPad hoặc Android Studio / VS Code.
// ============================================================

Future<void> main() async {
  print('========================================');
  print(' EXERCISE 1 – Product Model & Repository');
  print('========================================');
  await exercise1();

  print('\n========================================');
  print(' EXERCISE 2 – User Repository with JSON');
  print('========================================');
  await exercise2();

  print('\n========================================');
  print(' EXERCISE 3 – Async + Microtask Debugging');
  print('========================================');
  await exercise3();

  print('\n========================================');
  print(' EXERCISE 4 – Stream Transformation');
  print('========================================');
  await exercise4();

  print('\n========================================');
  print(' EXERCISE 5 – Factory Constructors & Cache');
  print('========================================');
  exercise5();
}

// ============================================================
//  EXERCISE 1 – Product Model & Repository
//  Mục tiêu: Hiểu Future và Stream.
// ============================================================

// --- Data model ---
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

// --- Repository ---
class ProductRepository {
  // StreamController dạng broadcast cho phép nhiều listener cùng lúc
  final _controller = StreamController<Product>.broadcast();

  /// Trả về danh sách sản phẩm giả lập sau 1 giây (mô phỏng gọi API)
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(seconds: 1)); // giả lập độ trễ mạng
    return [
      Product(id: 1, name: 'Laptop', price: 999.99),
      Product(id: 2, name: 'Phone', price: 499.49),
      Product(id: 3, name: 'Tablet', price: 299.00),
    ];
  }

  /// Stream phát sản phẩm mới theo thời gian thực
  Stream<Product> liveAdded() => _controller.stream;

  /// Thêm sản phẩm mới vào stream
  void addProduct(Product product) {
    _controller.add(product); // phát sự kiện tới tất cả listener
  }

  /// Đóng stream khi không còn sử dụng (tránh memory leak)
  void dispose() => _controller.close();
}

Future<void> exercise1() async {
  final repo = ProductRepository();

  // Lắng nghe stream TRƯỚC khi emit để không bỏ lỡ sự kiện
  final subscription = repo.liveAdded().listen(
    (product) => print('  [Stream] New product added: $product'),
  );

  // Lấy danh sách sản phẩm qua Future
  final products = await repo.getAll();
  print('  [Future] All products:');
  for (final p in products) {
    print('    $p');
  }

  // Phát sản phẩm mới qua stream
  repo.addProduct(Product(id: 4, name: 'Smartwatch', price: 199.99));
  repo.addProduct(Product(id: 5, name: 'Headphones', price: 149.00));

  // Chờ một chút để stream kịp xử lý trước khi đóng
  await Future.delayed(Duration(milliseconds: 100));

  await subscription.cancel();
  repo.dispose();
}

// ============================================================
//  EXERCISE 2 – User Repository with JSON
//  Mục tiêu: Luyện tập JSON serialization / deserialization.
// ============================================================

// --- Data model ---
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  /// Factory constructor để tạo User từ Map (JSON đã được parse)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  /// Giả lập dữ liệu JSON trả về từ API
  static const String _fakeApiResponse = '''
  [
    {"name": "Alice Nguyen",  "email": "alice@example.com"},
    {"name": "Bob Tran",      "email": "bob@example.com"},
    {"name": "Charlie Le",    "email": "charlie@example.com"}
  ]
  ''';

  /// Parse JSON và trả về danh sách User qua Future
  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(milliseconds: 800)); // giả lập độ trễ mạng

    // jsonDecode trả về dynamic; ép kiểu thành List<dynamic>
    final List<dynamic> jsonList = jsonDecode(_fakeApiResponse);

    // Chuyển mỗi phần tử Map thành đối tượng User
    return jsonList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> exercise2() async {
  final repo = UserRepository();
  final users = await repo.fetchUsers();

  print('  [JSON] Parsed users from API:');
  for (final u in users) {
    print('    $u');
  }
}

// ============================================================
//  EXERCISE 3 – Async + Microtask Debugging
//  Mục tiêu: Phân biệt microtask queue và event queue.
// ============================================================

Future<void> exercise3() async {
  print('  [Start] Synchronous code begins');

  // Future(() {}) đưa callback vào EVENT QUEUE (thực thi sau microtask)
  Future(() {
    print('  [Event Queue] Future callback – runs AFTER all microtasks');
  });

  // scheduleMicrotask đưa callback vào MICROTASK QUEUE (ưu tiên cao hơn)
  scheduleMicrotask(() {
    print('  [Microtask 1] scheduleMicrotask – runs before event queue');
  });

  // Future.microtask cũng đưa vào MICROTASK QUEUE
  Future.microtask(() {
    print('  [Microtask 2] Future.microtask – also before event queue');
  });

  print('  [Sync] Synchronous code ends');

  // Chờ để event queue hoàn tất trước khi in giải thích
  await Future.delayed(Duration(milliseconds: 50));

  print('');
  print('  >> Giải thích thứ tự thực thi:');
  print('     1. Code đồng bộ luôn chạy trước tiên.');
  print('     2. Microtask queue được xử lý TRƯỚC event queue.');
  print('     3. scheduleMicrotask và Future.microtask đều vào microtask queue.');
  print('     4. Future(() {}) vào event queue, chạy sau cùng.');
}

// ============================================================
//  EXERCISE 4 – Stream Transformation
//  Mục tiêu: Sử dụng các toán tử stream như map() và where().
// ============================================================

Future<void> exercise4() async {
  // Tạo stream số từ 1 đến 5
  final numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('  [Stream] Số bình phương chẵn (từ dãy 1–5):');

  await numberStream
      .map((n) => n * n)          // bình phương mỗi số: 1,4,9,16,25
      .where((n) => n.isEven)     // lọc chỉ giữ số chẵn: 4, 16
      .forEach((n) => print('    Squared & Even: $n'));

  // Hiển thị toàn bộ pipeline để dễ hình dung
  print('');
  print('  [Info] Pipeline: [1,2,3,4,5] → map(n*n) → [1,4,9,16,25]'
      ' → where(isEven) → [4,16]');
}

// ============================================================
//  EXERCISE 5 – Factory Constructors & Cache (Singleton)
//  Mục tiêu: Minh họa factory constructor và singleton pattern.
// ============================================================

class Settings {
  // Lưu instance duy nhất (singleton); null khi chưa khởi tạo
  static Settings? _instance;

  // Constructor private: ngăn tạo instance từ bên ngoài class
  Settings._internal() {
    print('  [Settings] Instance created (only happens once)');
  }

  /// Factory constructor: trả về instance đã có hoặc tạo mới nếu chưa có
  factory Settings() {
    // Toán tử ??= gán _instance nếu nó đang null
    _instance ??= Settings._internal();
    return _instance!;
  }

  // Các cấu hình ứng dụng (chia sẻ toàn cục qua singleton)
  String theme = 'dark';
  String language = 'vi';

  @override
  String toString() => 'Settings(theme: $theme, language: $language)';
}

void exercise5() {
  final s1 = Settings(); // tạo instance lần đầu
  final s2 = Settings(); // trả về instance đã có, KHÔNG tạo mới

  // Thay đổi qua s2 sẽ phản ánh trên s1 (cùng một object)
  s2.theme = 'light';

  print('  s1: $s1');
  print('  s2: $s2');
  print('  identical(s1, s2) → ${identical(s1, s2)}'); // phải là true

  // Xác nhận cả hai biến trỏ đến cùng một địa chỉ bộ nhớ
  if (identical(s1, s2)) {
    print('  ✅ Singleton confirmed: s1 and s2 are the SAME object.');
  }
}