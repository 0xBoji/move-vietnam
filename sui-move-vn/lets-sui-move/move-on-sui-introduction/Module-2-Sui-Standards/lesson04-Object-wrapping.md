# Object wrapping - Wrapping Sui Frens in Gift Boxes

Chúng ta đã tạo ra một loại object mới - GiftBox, có chứa một SuiFren bên trong. Nhưng làm thế nào để chúng ta đưa một SuiFren vào đó? Có hai lựa chọn:

1. Tạo một hàm mới trong sui_fren - create, tạo ra một object SuiFren và trả về nó, thay vì ngay lập tức chuyển nó cho người gửi như hàm mint.
2. Mint SuiFren trước. Sau khi chuyển giao đã diễn ra trong mint, chúng ta không thể lấy lại SuiFren trong cùng một giao dịch và cần phải làm điều đó trong một giao dịch tiếp theo trong khi truyền rõ ràng SuiFren đó vào làm tham số. Chúng ta có thể thêm một hàm wrap trong `fren_summer` cho phép người gửi bao bọc một SuiFren hiện có và tạo một hộp quà. Họ có thể gửi nó cho bạn bè sau đó.
Trong trường hợp thứ hai, việc đưa SuiFren vào GiftBox được gọi là <b>object wrapping<b>. Điều này làm nhiều hơn bạn nghĩ - nó lấy object được bao bọc ra khỏi lưu trữ object. Điều này có nghĩa là nếu bạn có một giao diện hiển thị tất cả SuiFrens mà người dùng sở hữu, SuiFren mà họ đã bao bọc sẽ biến mất khỏi danh sách.

```move
struct Box has key {
    id: UID,
    thing: Thing,
}

struct Thing has key, store {
    id: UID,
}

public fun wrap(thing: Thing, ctx: &mut TxContext) {
    let box = Box { id: object::new(ctx), thing };
    transfer::transfer(box, tx_context::sender(ctx));
}
```

Lưu ý rằng hàm `wrap` nhận một giá trị, không phải tham chiếu! Chúng ta đã đề cập đến việc truyền object theo giá trị trong khóa học trước và cách điều này loại bỏ object khỏi lưu trữ.

## Quiz

Hãy thêm một vài hàm mới:

1. Thêm một hàm `friend` vào module `sui_fren` - `create`, có cùng tham số như mint và tạo ra và trả về một SuiFren.
2. Thêm một hàm entry mới vào `fren_summer` - `create_gift`, có cùng tham số như `sui_fren::create`, gọi `sui_fren::create` để tạo một SuiFren, đặt nó vào một GiftBox và gửi GiftBox cho người gửi.
3. Thêm một hàm entry mới vào `fren_summer` - `wrap_fren`, nhận một tham số SuiFren hiện có tên là fren, bao bọc nó trong một GiftBox và gửi GiftBox cho người gửi.

```move
module 0x123::fren_summer {
    use sui::object::{Self, UID};
    use 0x123::sui_fren::{Self, SuiFren};
    use sui::tx_context;

    struct GiftBox has key {
        id: UID,
        inner: SuiFren,
    }

    // thêm func mới vào đây
}

module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    use sui::event;

    friend 0x123::fren_summer;
    
    struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    // thêm func mới vào đây

    public(friend) fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let sui_fren = SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
    }
}
```

## Đáp án

```move
module 0x123::fren_summer {
    use sui::object::{Self, UID};
    use 0x123::sui_fren::{Self, SuiFren};
    use sui::tx_context;

    struct GiftBox has key {
        id: UID,
        inner: SuiFren,
    }

    entry fun create_gift(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let fren = sui_fren::create(generation, birthdate, attributes, ctx);
        let gift_box = GiftBox {
            id: object::new(ctx),
            inner: fren,
        };
        transfer::transfer(gift_box, tx_context::sender(ctx));
    }

    entry fun wrap_fren(fren: SuiFren, ctx: &mut TxContext) {
        let gift_box = GiftBox {
            id: object::new(ctx),
            inner: fren,
        };
        transfer::transfer(gift_box, tx_context::sender(ctx));
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
    
    struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    public(friend) fun create(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext): SuiFren {
        SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        }
    }

    public(friend) fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let sui_fren = SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
    }
}
```

## Ví dụ Minh Họa

Ví dụ về hàm `create` và `mint`:

```module 0x123::token {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    struct Token has key, store {
        id: UID,
        value: u64,
    }

    public(friend) fun create(value: u64, ctx: &mut TxContext): Token {
        Token {
            id: object::new(ctx),
            value,
        }
    }

    public(friend) fun mint(value: u64, ctx: &mut TxContext) {
        let token = create(value, ctx);
        transfer::transfer(token, tx_context::sender(ctx));
    }
}
```

Ví dụ về hàm `wrap`:

```move
module 0x123::gift {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    struct WrappedToken has key {
        id: UID,
        token: Token,
    }

    entry fun wrap(token: Token, ctx: &mut TxContext) {
        let wrapped_token = WrappedToken {
            id: object::new(ctx),
            token,
        };
        transfer::transfer(wrapped_token, tx_context::sender(ctx));
    }
}
```

Các ví dụ này minh họa cách các hàm `create`, `mint`, và `wrap` hoạt động trong thực tế, cho phép chúng ta tạo và quản lý các object một cách linh hoạt và an toàn.



