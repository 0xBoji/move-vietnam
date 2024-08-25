# Các cấu trúc dữ liệu trong Move

## Simple Map (Bản đồ đơn giản):

Simple Map trong Aptos Move là cách để tạo một bản đồ lưu trữ một số lượng nhỏ phần tử. Simple Map dễ sử dụng và có thể xem dễ dàng thông qua một yêu cầu API duy nhất khi được lưu trữ trong tài nguyên. Nếu nhà phát triển mong đợi có hàng trăm phần tử trong bản đồ, họ nên cân nhắc sử dụng SmartVector hoặc SmartTable thay thế.

Ví dụ cách sử dụng Simple Map:
```
use aptos_std::simple_map;

let my_map = simple_map::new<u64, u64>();
simple_map::add(&mut my_map, 1, 4);
simple_map::add(&mut my_map, 2, 5);
simple_map::add(&mut my_map, 3, 6);

let value = simple_map::borrow(&my_map, &1);
```

## Table (Bảng):

Table trong Move có thể được sử dụng để lưu trữ dữ liệu trong các mục riêng biệt trong bộ nhớ. Table thường hữu ích để lưu trữ dữ liệu cho từng người dùng có thể truy cập độc lập và hiệu quả.

Ví dụ cách sử dụng Table:

```
use aptos_std::table;

let my_table = table::new<u64, u64>();
table::add(&my_table, 1, 2);
table::add(&my_table, 3, 4);

let ref = table::borrow(&my_table, 1);
```

## Smart Vector:

Smart Vector có thể được coi như một vector được tạo ra cho một lượng lớn các mục trong khi tối ưu hóa chi phí gas cho người dùng. Smart Vector thực hiện điều này bằng cách lưu trữ dữ liệu trong các "bucket" với mỗi bucket là một vector bình thường.

Ví dụ cách sử dụng Smart Vector:

```
use aptos_std::smart_vector;

let my_smart_vector = smart_vector::new<u64>();
smart_vector::push_back(&my_smart_vector, 1);
smart_vector::push_back(&my_smart_vector, 2);
smart_vector::push_back(&my_smart_vector, 3);

let element = smart_vector::borrow(&my_smart_vector, 0);
```

## Smart Table:

Smart Table tương tự như Smart Vector, nhưng dành cho cấu trúc bảng. Nó lưu trữ các mục trong các bucket với mỗi bucket là một vector.

Ví dụ cách sử dụng Smart Table:

```
use aptos_std::smart_table;

let my_table = smart_table::new<u64, u64>();
smart_table::add(&my_table, 1, 2);
smart_table::add(&my_table, 3, 4);
smart_table::add(&my_table, 5, 6);

let ref = smart_table::borrow(&my_table, 1);
```

Mỗi cấu trúc dữ liệu có ưu và nhược điểm riêng, và việc lựa chọn cấu trúc dữ liệu phù hợp phụ thuộc vào yêu cầu cụ thể của ứng dụng và số lượng dữ liệu cần lưu trữ.
