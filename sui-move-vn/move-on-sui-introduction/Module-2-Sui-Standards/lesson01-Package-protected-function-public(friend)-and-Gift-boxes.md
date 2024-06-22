# Package protected function - public(friend) and Gift boxes
Trong khóa học trước, chúng ta đã đề cập đến các khái niệm cơ bản trong Sui Move: Modules (mô-đun), Functions (hàm), Objects (đối tượng) và Events (sự kiện). Trong khóa học này, chúng ta sẽ đi sâu hơn vào các khái niệm hữu ích khác trong Move và Objects, cho phép chúng ta xây dựng một thế giới Sui Fren phức tạp và thú vị hơn.

Hãy bắt đầu với các hàm. Trong khóa học trước, chúng ta đã thấy các hàm công khai và riêng tư:

- Các hàm công khai có thể được gọi bởi các giao dịch (thông qua Programmable Transaction Blocks mà chúng ta sẽ đề cập sau) và cũng bởi mã Move khác (cùng hoặc khác module).
- Các hàm riêng tư chỉ có thể được gọi trong cùng một module.
```move
module 0x123::my_module {
    public fun public_equal(x: u64): bool {
        x == 1000
    }
    
    fun private_equal(x: u64): bool {
        x == 1000
    }
}
```
Nếu bạn nhớ, các module được nhóm lại thành các package để triển khai trên Sui. Điều này dẫn đến một loại thứ ba của tính khả kiến của hàm - public(friend). Các hàm public(friend) tương tự như các hàm chỉ có thể nhìn thấy trong package ở các ngôn ngữ khác và chỉ có thể được gọi bởi các module trong cùng một package. Điều này cho phép các nhà phát triển hạn chế các hàm nguy hiểm chỉ được gọi bởi các module của họ mà không phải bởi các module khác.
```move
module 0x123::my_other_module {
    use 0x123::my_module;

    public fun do_it(x: u64): bool {
        my_module::friend_only_equal(x)
    }
}

module 0x123::my_module {
    friend 0x123::my_other_module;

    public(friend) fun friend_only_equal(x: u64): bool {
        x == 1000
    }
}
```

Để tạo một hàm public(friend), chúng ta chỉ cần sử dụng từ khóa khả kiến tương ứng - public(friend). Bất kỳ module nào như 0x123::my_other_module trong ví dụ trên muốn gọi hàm public(friend) cũng cần phải được khai báo rõ ràng là "friend" - friend 0x123::my_other_module. Việc khai báo rõ ràng này hiện tại là bắt buộc nhưng nhóm phát triển Sui Move đang có kế hoạch để việc này không cần thiết trong tương lai. Điều này sẽ thực sự làm cho các hàm public(friend) khả kiến trong toàn bộ package.

## Quiz
Hiện tại, bất kỳ ai cũng có thể tạo Sui Frens. Hãy:

Làm cho hàm mint chỉ có thể được gọi bởi friend.
Thêm một module mới `0x123::fren_summer` với một hàm công khai `open_box` có cùng chữ ký như `sui_fren::mint` (tạm thời) và gọi `sui_fren::mint` ở đó. Chúng tôi sẽ giải thích hàm này sẽ được sử dụng như thế nào trong các bài học tiếp theo.

```// Thêm module và hàm mới ở đây

module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    use sui::event;

    // Khai báo friend ở đây
    friend 0x123::fren_summer;

    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    struct MintEvent has copy, drop {
        id: ID,
    }

    // Cập nhật hàm mint
    public(friend) fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let uid = object::new(ctx);
        let id = object::uid_to_inner(&uid);
        let sui_fren = SuiFren {
            id: uid,
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
        event::emit(MintEvent {
            id,
        });
    }
}

module 0x123::fren_summer {
    use 0x123::sui_fren;

    public fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}
```

## Đáp án

```module 0x123::fren_summer {
    use 0x123::sui_fren;

    public fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}

module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    use sui::event;

    friend 0x123::fren_summer;
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    struct MintEvent has copy, drop {
        id: ID,
    }

    public(friend) fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let uid = object::new(ctx);
        let id = object::uid_to_inner(&uid);
        let sui_fren = SuiFren {
            id: uid,
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
        event::emit(MintEvent {
            id,
        });
    }
}```