# Lab 11.5 - Test Suite Summary

## 1. Overview
- **Total number of tests:** 8 tests (across 4 files).
- **Types of tests:** 
  - Unit Tests (3 cho Task Model, 3 cho Task Repository)
  - Widget Tests (3 cho TaskList UI)
  - Navigation Tests (1 test)
  - Integration Tests (1 test cho toàn bộ luồng)

## 2. Behaviors Validated
- **Task Model:** Kiểm tra giá trị khởi tạo mặc định của `isCompleted` là `false`. Đảm bảo phương thức `toggle()` đảo ngược chính xác trạng thái từ `true` sang `false` và ngược lại.
- **Task Repository:** Xác nhận tính đúng đắn khi thêm (add), sửa (update), và xóa (delete) công việc khỏi danh sách nội bộ.
- **Task List UI:** Kiểm tra trạng thái trống (Empty State) hiển thị đúng message, kiểm tra luồng thêm công việc qua TextField và Icon add, kiểm tra việc render chính xác khi có nhiều task cùng lúc.
- **Navigation:** Xác thực việc bấm vào một Task trên danh sách sẽ kích hoạt Navigator chuyển sang `TaskDetailScreen` và hiển thị đúng dữ liệu (tiêu đề TextField).
- **Integration Flow:** Xác minh luồng end-to-end: Thêm Task -> Mở Detail -> Chỉnh sửa tên Task -> Lưu -> Kiểm tra Task mới đã xuất hiện trong danh sách và cập nhật UI thành công.

## 3. Known Limitations
- Dữ liệu hiện tại chỉ lưu trữ trên RAM (in-memory) trong `TaskRepository`, sẽ bị mất khi khởi động lại ứng dụng. (Cần tích hợp SharedPreferences hoặc SQLite/Hive ở các lab sau).
- Chưa test trường hợp nhập chuỗi rỗng vào TextField rồi bấm Add (ứng dụng đang bỏ qua `return` nhưng chưa có feedback lỗi cho UI).
