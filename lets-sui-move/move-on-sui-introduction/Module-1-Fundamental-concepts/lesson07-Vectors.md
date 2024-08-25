# Vectors
Khi bạn muốn có một danh sách các giá trị, hãy sử dụng vector. Vector trong Move là động theo mặc định và không có kích thước cố định. Nó có thể phát triển và thu nhỏ tùy theo nhu cầu. Vector trong Sui được nhập khẩu mặc định và không cần phải được thêm vào một cách rõ ràng. Bạn chỉ cần sử dụng use std::vector ở đầu module của mình để có thể truy cập nó. Chúng ta sẽ nói về các cấu trúc dữ liệu và thư viện khác có sẵn để sử dụng trong một khóa học sau. Ví dụ:

```move
module 0x123::my_module {
   use std::vector;
   use sui::object::{Self, UID};

   struct MyObject has key {
       id: UID,
       values: vector<u64>,
       bool_values: vector<bool>,
       address_values: vector<address>,
   }
}
```

Bạn cũng có thể lưu trữ các object trong vector bằng cách tham chiếu các struct. Lưu ý rằng để một object được lưu trữ trong trường của object khác, struct của nó cần có khả năng store:

```move
module 0x123::my_module {
   use std::vector;
   use sui::object::{Self, UID};

   struct NestedObject has key, store {
       id: UID,
       owner: address,
       balance: u64,
   }

   struct GlobalData has key {
       id: UID,
       wrapped_objects: vector<NestedObject>,
   }
}
```

Khi tạo một vector trống, bạn có thể sử dụng cú pháp sau:

```
fun init() {
   // Vector trống này chưa có kiểu được khai báo. Giá trị đầu tiên được thêm vào sẽ xác định kiểu của nó.
   let empty_vector = vector[];
   let int_vector = vector[1, 2, 3];
   let bool_vector = vector[true, true, false];
}

```

## Quiz:

Định nghĩa một cấu trúc mới là SuiFren object có các trường sau: thế hệ kiểu u64, ngày sinh kiểu u64 và thuộc tính là một vector của chuỗi. Đừng quên thêm câu lệnh nhập khẩu cho vector.

```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    
    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    // Add the new SuiFren struct here
}
```

## Đáp án:
```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    
    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    // Add the new SuiFren struct here
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }
}
```

## Bonus:
Ví dụ vui
Giả sử bạn đang tạo một trò chơi nuôi thú ảo, và mỗi "thú ảo" được đại diện bởi một SuiFren. Mỗi thú ảo này có một danh sách các thuộc tính như "dễ thương", "hiếu động", "ngủ nhiều" được lưu trữ trong một vector. Bạn cần nhập liệu cho một thú ảo mới như sau:

```move
module pet_simulator {
    use std::vector;

    struct SuiFren {
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    fun add_new_pet(generation: u64, birthdate: u64, attributes: vector<String>) {
        let new_pet = SuiFren {
            generation,
            birthdate,
            attributes,
        };
        // Giả sử tiếp tục xử lý thêm new_pet vào hệ thống
    }
}
```

Ở đây, mỗi "SuiFren" mới tượng trưng cho một thế hệ và có một danh sách các thuộc tính miêu tả tính cách và đặc điểm. Điều này làm cho trò chơi thêm phần sinh động và thú vị, khi người chơi có thể xem và quản lý các thuộc tính độc đáo của "thú ảo" của họ.