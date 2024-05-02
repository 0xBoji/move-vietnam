# Public vs Private Functions

Trong các ví dụ trước, chúng ta chỉ sử dụng hàm init, hàm này tạo object AdminCap. Hàm init này phải là hàm riêng tư và được gọi tự động bởi Máy ảo Sui (VM) khi module được triển khai.

Trong bài học này, chúng ta sẽ tạo một hàm công khai mà người dùng sẽ gọi để tạo một Fren mới. Hàm công khai trong Move trông như thế này:

```move
public fun equals_1000(x: u64): bool {
       x == 1000
}
```

Lưu ý rằng hàm này có từ khóa public, có nghĩa là nó có thể được gọi từ bất kỳ module Move nào khác và từ các giao dịch. Ngược lại, các hàm riêng tư chỉ có thể được gọi trong cùng một module và không thể được gọi từ các giao dịch. Khi các giao dịch công khai được gọi, các object hệ thống như TxContext và Clock có thể được truyền một cách tùy chọn. Việc thêm các object này vào danh sách đối số là tùy thuộc vào bạn nếu hàm của bạn cần chúng. Thực hành tốt: Các object hệ thống cần luôn nằm ở cuối danh sách đối số.

## Quiz:

Tạo một hàm công khai mới có tên là mint với bốn đối số và trả về một object SuiFren:

1. generation và birthdate kiểu u64
2. attributes kiểu vector<String>
3. ctx kiểu &mut TxContext.

Gợi ý: Bạn có thể sử dụng hình thức rút gọn sau khi tên trường và giá trị của struct giống nhau:

```move
struct MyStruct {
   value: u64,
}
let value = 1;
MyStruct {
   value,
}
```
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
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }
}

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
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    // Add the new function here
}
```


# Đáp án:

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
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }
}

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
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext): SuiFren {
        SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        }
    }
}
```

## Bonus
Ví dụ vui
Tưởng tượng bạn đang chạy một cửa hàng bán bánh kem, và mỗi bánh kem là một "SuiFren" với các đặc điểm như "số lượng tầng", "ngày làm", và một danh sách các "hương vị" dưới dạng vector. Một khách hàng muốn đặt một chiếc bánh kem đặc biệt cho ngày sinh nhật của mình như sau:

```move
module cake_shop {
    use std::vector;

    struct CakeFren {
        layers: u64,
        made_date: u64,
        flavors: vector<String>,
    }

    public fun order_special_cake(layers: u64, made_date: u64, flavors: vector<String>, ctx: &mut TxContext): CakeFren {
        CakeFren {
            layers,
            made_date,
            flavors,
        }
    }
}
```

Ở đây, mỗi "CakeFren" được tạo ra cho một đơn đặt hàng cụ thể, và khách hàng có thể tùy chọn số tầng, ngày làm và hương vị. Quá trình này không chỉ giúp đáp ứng nhu cầu cá nhân hóa của khách hàng mà còn mang lại niềm vui khi họ tham gia vào quá trình tạo ra chiếc bánh của chính họ!