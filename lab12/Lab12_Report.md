# Lab 12 - Performance Optimization & Deployment Report

## Exercise 12.1 — Optimize List Rebuilds
- **Các tối ưu đã áp dụng:**
  - Chuyển từ việc truyền `TaskRepository` trực tiếp sang dùng State Management với thư viện `provider` (Sử dụng `TaskProvider` kế thừa `ChangeNotifier`).
  - Tách widget hiển thị từng item trong danh sách ra thành file riêng `lib/widgets/task_tile.dart`. 
  - Gán `ValueKey(task.id)` cho mỗi `TaskTile` để Flutter có thể nhận diện các phần tử trong danh sách khi cây widget thay đổi mà không cần tạo lại (rebuild) toàn bộ list.
  - Sử dụng `Selector` (hoặc `Consumer` bọc ListView) thay vì rebuild cả `TaskListScreen` giúp giảm thiểu số lượng frame bị tụt khi user tick Checkbox.
  - Bổ sung `const` vào các widget tĩnh (static widgets) để giảm overhead cấp phát bộ nhớ.

## Exercise 12.2 — Image & Asset Optimization
- **Các tối ưu đã áp dụng:**
  - Bổ sung một hình ảnh logo nhỏ (`assets/images/logo.png`, kích thước 128x128).
  - Tích hợp ảnh vào trong UI của app bar.
  - Sử dụng phương thức `precacheImage` ở bên trong `didChangeDependencies` (hoặc `initState`) để tải trước hình ảnh vào bộ nhớ cache, ngăn chặn hiện tượng nhảy layout khi ảnh load muộn.
- Không có asset nào dư thừa chưa được sử dụng.

## Exercise 12.3 — App Size Analysis
Báo cáo phân tích kích thước ứng dụng (`flutter build apk --analyze-size --target-platform android-arm64`) cho kết quả như sau:
- **Total APK size:** ~15.6 MB
- **Top 3 components taking the most space:**
  1. Thư viện native C/C++ (`lib/arm64-v8a`): chiếm phần lớn không gian, khoảng 15 MB.
  2. `Dart AOT symbols` (Phân vùng symbol của Dart): khoảng 4 MB. Trong đó thư viện lõi `package:flutter` tốn khoảng 2 MB.
  3. Classes DEX (`classes.dex`): ~ 231 KB.
- **Optimization Suggestions (Đề xuất tối ưu):**
  - **Tách kiến trúc CPU (App Bundle thay vì APK):** Nếu upload lên Google Play, khuyến cáo luôn sử dụng lệnh `flutter build appbundle`. Google Play sẽ tự tách các file `.so` thừa (ví dụ x86, arm32) để giảm kích thước tải xuống cho từng thiết bị cụ thể.
  - **Obfuscation (Xóa dấu vết mã):** Có thể chạy build với flag `--obfuscate --split-debug-info=/<project-name>/<directory>` để làm xáo trộn mã nguồn và loại bỏ thông tin debug dư thừa, giúp giảm kích thước APK thêm một chút.

## Exercise 12.4 — Final Optimization & Deployment (Comprehensive)
### Performance Checklist
- [x] Không còn `print()` hoặc log debug thừa trong Production.
- [x] Đã đánh dấu `const` tối đa cho các Widget không thay đổi.
- [x] Đã sử dụng Provider để tránh Rebuild cục bộ diện rộng.
- [x] Các assets hình ảnh đã được thu nhỏ kích thước.
- [x] Tree-shaking cho Material Icons đã được tự động áp dụng (giảm từ 1.6MB xuống còn ~1.5KB).
- [x] Đã chạy `flutter clean` và build release bản cuối.

### Short Summary: Why the app is now ready for deployment?
Ứng dụng Taskly giờ đây đã sẵn sàng để phát hành (deployment) vì nó đã giải quyết được vấn đề cổ chai (bottleneck) ở UI do rebuild quá mức. App bundle đã loại bỏ các resource và file mã không cần thiết, mã nguồn Dart đã được biên dịch sang định dạng AOT tối ưu cho nền tảng di động. Những cải tiến về cache hình ảnh và chia cắt Widget thành các component độc lập cũng giúp duy trì mốc 60 FPS một cách ổn định ở thiết bị người dùng cuối.
