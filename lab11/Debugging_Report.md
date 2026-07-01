# Lab 11.4 - Debugging Report

## DevTools Screenshots
*(Sinh viên đính kèm 2 ảnh chụp màn hình Widget Inspector và Performance Timeline vào đây hoặc trong thư mục nộp bài)*

## 1. Potential Layout Issue
**Vấn đề:** 
Khi sử dụng `ListView.builder` bên trong `Column` ở `TaskListScreen`, nếu không được bọc trong widget `Expanded` hoặc `Flexible`, Flutter sẽ báo lỗi `RenderFlex children have non-zero flex but incoming height constraints are unbounded`. 
**Cách DevTools giúp phát hiện:**
- **Widget Inspector** giúp hiển thị cảnh báo lỗi overflow (với dải băng sọc vàng/đen).
- Tính năng **Layout Explorer** trong DevTools cho phép xem kích thước và giới hạn constraint của từng widget, từ đó giúp dễ dàng nhận diện widget cha (`Column`) cung cấp unbounded height.

## 2. Potential Performance Issue
**Vấn đề:**
Khi click Checkbox để hoàn thành một Task, toàn bộ `TaskListScreen` sẽ bị rebuild vì `setState()` được gọi ở cấp độ toàn màn hình. Khi danh sách có hàng ngàn Task, việc rebuild toàn bộ danh sách sẽ gây sụt giảm khung hình (jank).
**Cách DevTools giúp phát hiện:**
- **Performance Timeline** ghi lại các Track của UI và Raster thread.
- Bật **Track Widget Builds** sẽ thấy số lượng widget bị rebuild tăng đột biến mỗi khi click Checkbox. Từ đó, lập trình viên có thể biết để tối ưu bằng cách tách Checkbox ra thành một StatefulWidget riêng biệt hoặc dùng các state management (Provider, Bloc) để chỉ rebuild đúng dòng (row) đó.
