# Module Trong Move
 Trong Move, code được tổ chức thành các module. Mỗi module tương đương với một hợp đồng thông minh trên các blockchain (Sui). Tuy nhiên, Move cung cấp nhiều chức năng hơn giúp tổ chức code thành các phần nhỏ hơn và linh hoạt hơn. Mỗi module cung cấp một API thông qua các hàm nhập và công khai của nó. Người dùng có thể tương tác với các module bằng cách gọi các hàm từ các module này thông qua các giao dịch hoặc qua code Move khác. Các giao dịch được gửi đến và xử lý bởi blockchain Sui và một khi được thực thi, các thay đổi kết quả sẽ được lưu lại. Công nghệ này tương tự như stack Web 2, nơi các module Move hoạt động như máy chủ với các đường dẫn/API khác nhau, blockchain Sui hoạt động như khung chạy máy chủ và cung cấp cơ sở dữ liệu để lưu trữ dữ liệu. Sau đó, các developer có thể xây dựng giao diện người dùng kết nối với máy chủ và cơ sở dữ liệu này để cung cấp các chức năng phong phú cho người dùng của họ.
## Ví dụ về Module trong Move 
## Giả sử chúng ta có một module được triển khai như sau:


```
module 0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3::pool_script {
    // Các hàm và dữ liệu cụ thể cho pool_script sẽ được định nghĩa ở đây
}

```

## Các developer thường triển khai các module cùng nhau như một gói duy nhất, được gán cho một đối tượng và có địa chỉ riêng của nó như 
`0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3`
## Module sau đó có thể được tham chiếu với địa chỉ đối tượng và tên của nó: 
`0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3::pool_script`
 Trong trường hợp này, tên của module là pool_script. Move cũng cho phép sử dụng bí danh cho địa chỉ bằng cách định nghĩa nó trong Move.toml (ví dụ: cetus=0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3 và sau đó định nghĩa module như cetus::pool_script). Khi gọi một hàm trên module này, người dùng có thể gửi nội dung giao dịch kích hoạt 0x996c4d9480708fb8b92aa7acf819fb0497b5ec8e65ba06601cae2fb6db3312c3::pool_script::open_position nơi open_position là tên của hàm. Định dạng chuẩn này của module và định danh hàm làm cho việc triển khai, quản lý và tích hợp với các module Move trở nên dễ dàng. Thiết kế module được khuyến khích mạnh mẽ trên Sui và các developer nên giữ mỗi module càng nhỏ càng tốt và trong tệp riêng của nó. Điều này giữ cho cấu trúc dữ liệu và mã sạch sẽ, đồng thời làm cho việc tích hợp với các module và cho người dùng dễ dàng hiểu mỗi giao dịch mà họ gửi. Điều này tương tự như các nguyên tắc phát triển Web 2 như Nguyên tắc Trách nhiệm Đơn lẻ (SRP).