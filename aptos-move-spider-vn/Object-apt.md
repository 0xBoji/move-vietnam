# Đối tượng (Object)

Mô hình Đối tượng cho phép Move biểu diễn một kiểu phức tạp dưới dạng một tập hợp các tài nguyên được lưu trữ trong một địa chỉ duy nhất và cung cấp một mô hình khả năng phong phú cho phép kiểm soát tài nguyên và quản lý quyền sở hữu chi tiết.
Các thuộc tính của mô hình Đối tượng:

Giao diện lưu trữ đơn giản hóa hỗ trợ một tập hợp các tài nguyên không đồng nhất được lưu trữ cùng nhau.
Mô hình dữ liệu và quyền sở hữu có thể truy cập toàn cục cho phép người tạo và nhà phát triển điều khiển ứng dụng và vòng đời của dữ liệu.
Mô hình lập trình mở rộng hỗ trợ cá nhân hóa các ứng dụng người dùng tận dụng framework cốt lõi bao gồm các token.
Hỗ trợ phát ra các sự kiện trực tiếp, cải thiện khả năng khám phá các sự kiện liên quan đến đối tượng.
Cân nhắc hệ thống cơ bản bằng cách tận dụng các nhóm tài nguyên để hiệu quả gas, tránh chi phí giải tuần tự hóa và tuần tự hóa tốn kém, và hỗ trợ khả năng xóa.

Đối tượng là một nguyên thủy cốt lõi trong Aptos Move và được tạo thông qua mô-đun đối tượng tại 0x1::object.