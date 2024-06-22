# Programmable Transaction Block and Entry functions: Open gift boxes
Một loại hàm quan trọng khác là hàm entry. Trong ngôn ngữ Move cũ, có hai loại hàm entry - public entry và private entry.
Trên mạng Sui, một Khối Giao Dịch Lập Trình Được (Programmable Transaction Block - PTB) cho phép user chỉ định một loạt các hành động (giao dịch) được gửi tới mạng như một giao dịch duy nhất. Các hành động này được thực thi tuần tự và mang tính nguyên tử - nếu bất kỳ hành động nào thất bại, toàn bộ PTB sẽ thất bại và tất cả các thay đổi sẽ tự động được hoàn nguyên. PTB là một khái niệm mạnh mẽ sẽ được đề cập thêm trong các khóa học sau. Hiện tại, chúng ta sẽ xem PTB là các giao dịch mà user gửi đến blockchain Sui. PTB có thể gọi bất kỳ hàm public, public entry và private entry nào được viết trong các module Move. Do đó, thực tế không có sự khác biệt giữa hàm public và public entry trong Sui mặc dù những khái niệm này vẫn được kế thừa từ Move cổ điển.

Loại hàm mới duy nhất chúng ta cần học là các hàm private entry, chỉ có thể được gọi trực tiếp từ một giao dịch, nhưng không thể từ mã Move khác.

Các hàm private entry (viết tắt là entry functions) hữu ích khi các developer muốn cung cấp các tính năng trực tiếp cho user mà chỉ có thể được gọi như một phần của giao dịch nhưng không trong module khác. Một ví dụ có thể là cắt vé - chúng ta muốn user phải gọi rõ ràng điều này như một phần của giao dịch và không muốn các module khác cắt vé của user thay họ. Điều này khó phát hiện hơn cho user và họ có thể không mong đợi điều này xảy ra khi gửi một giao dịch.

```entry fun clip_ticket(ticket: Ticket) {
    let Ticket {
        id,
        expiration_time: _,
    } = ticket;
    object::delete(id);
}
```

## Quiz
Cập nhật `fren_summer::open_box` thành hàm private entry.

```move 
module 0x123::fren_summer {
    use 0x123::sui_fren;

    entry fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}
```

## Đáp án

```move
module 0x123::fren_summer {
    use 0x123::sui_fren;

    entry fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}
```

## Ví dụ Minh Họa

Ví dụ về Programmable Transaction Block (PTB):
```move
module 0x123::ticketing {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct Ticket has key {
        id: UID,
        event: String,
        holder: address,
    }

    entry fun buy_ticket(event: String, holder: address, ctx: &mut TxContext) {
        let ticket = Ticket {
            id: object::new(ctx),
            event,
            holder,
        };
        transfer::transfer(ticket, holder);
    }

    entry fun use_ticket(ticket: Ticket) {
        let Ticket {
            id,
            event: _,
            holder: _,
        } = ticket;
        object::delete(id);
    }
}
```

Trong ví dụ này, `buy_ticket` và `use_ticket` là các hàm entry cho phép user mua và sử dụng vé như một phần của giao dịch. Những hành động này phải được gọi trực tiếp từ một giao dịch do user khởi tạo.

Ví dụ về Entry Private functions:
```move
module 0x123::event_management {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::string::String;

    struct Event has key {
        id: UID,
        name: String,
        date: u64,
    }

    entry fun create_event(name: String, date: u64, ctx: &mut TxContext) {
        let event = Event {
            id: object::new(ctx),
            name,
            date,
        };
        // Chỉ lưu đối tượng, không chuyển giao cho bất kỳ ai
    }

    entry fun cancel_event(event: Event) {
        let Event {
            id,
            name: _,
            date: _,
        } = event;
        object::delete(id);
    }
}
```
Trong ví dụ này, `create_event` và `cancel_event` là các hàm entry private, cho phép user tạo và hủy event như một phần của giao dịch mà không thể gọi từ các module khác.