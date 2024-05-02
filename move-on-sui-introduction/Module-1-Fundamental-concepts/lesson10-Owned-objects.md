# Owned Objects:

Trong các bài học trước, chúng ta đã học cách tạo, đọc và chỉnh sửa đối tượng SuiFren mà được chia sẻ giữa tất cả người dùng.

Có hai loại Đối tượng:

Đối tượng Chia sẻ (<strong>Shared Objects</strong>) có thể được đọc và chỉnh sửa bởi bất kỳ người dùng nào. Trước đây chúng ta đã tạo AdminCap thành một đối tượng chia sẻ, điều này sẽ cho phép bất kỳ ai cũng có thể tạo Sui Frens. Điều này có thể không phải là hành vi mong muốn.

Đối tượng Sở hữu (<strong>Owned Objects</strong>) là các đối tượng riêng tư mà chỉ những người dùng sở hữu chúng mới có thể đọc và chỉnh sửa. Quyền sở hữu được xác minh tự động như một phần của việc thực thi giao dịch trên Sui. Lưu ý rằng chỉ cho phép sở hữu trực tiếp, vì vậy nếu người dùng A sở hữu đối tượng B và đối tượng B sở hữu đối tượng C, người dùng A không thể gửi giao dịch bao gồm đối tượng C. Có một giải pháp cho điều này bằng cách sử dụng Receiving<T> nhưng chúng ta sẽ đề cập đến điều này sau.

Hãy chỉnh sửa ví dụ Vé của chúng ta trong các bài học trước để tạo vé thực sự được cấp cho từng người dùng thay vì có thể truy cập bởi tất cả:

```move
module 0x123::ticket_module {
  use sui::clock::{Self, Clock};
  use sui::object::{Self, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};
 
  struct Ticket has key {
      id: UID,
      expiration_time: u64,
  }
 
  public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
        let ticket = Ticket {
             id: object::new(ctx),
             expiration_time: clock::timestamp_ms(clock),
        };
        // tx_context::sender(ctx) trả về địa chỉ của người dùng gửi giao dịch này.
        transfer::transfer(ticket, tx_context::sender(ctx));
  }
 
  public fun is_expired(ticket: &Ticket, clock: &Clock): bool {
     ticket.expiration_time >= clock::timestamp_ms(clock)
  }
}
```

Để làm cho các đối tượng Ticket trở thành sở hữu, chúng ta chỉ cần chuyển rõ ràng đối tượng cho một địa chỉ thay vì gọi `transfer::share` như trước. Ở đây, chúng ta chuyển vé mới tạo cho người dùng gửi giao dịch gọi hàm `create_ticket`. Để lấy địa chỉ của người dùng, chúng ta sử dụng `tx_context::sender(ctx)`.

## Quizz

Cập nhật hàm mint để gửi SuiFren mới tạo đến người gửi giao dịch thay vì trả về nó.

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

## Đáp án:

```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
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

    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
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

## Bonus:

Ví dụ vui
Tưởng tượng rằng bạn đang chạy một sân bay ảo và mỗi vé máy bay là một "Ticket" được cấp cho mỗi hành khách. Mỗi hành khách khi check-in sẽ nhận được vé máy bay của họ thông qua một giao dịch trên blockchain:

```move
module virtual_airport {
    use sui::clock::{Self, Clock};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct FlightTicket has key {
        id: UID,
        flight_time: u64,
    }

    public fun issue_ticket(ctx: &mut TxContext, clock: &Clock) {
        let flight_ticket = FlightTicket {
             id: object::new(ctx),
             flight_time: clock::timestamp_ms(clock),
        };
        transfer::transfer(flight_ticket, tx_context::sender(ctx));
    }

    public fun check_if_flight_expired(flight_ticket: &FlightTicket, clock: &Clock): bool {
        flight_ticket.flight_time < clock::timestamp_ms(clock)
    }
}
```

Ở đây, mỗi "FlightTicket" được cá nhân hóa cho từng hành khách, đảm bảo rằng chỉ có người sở hữu vé mới có thể sử dụng để lên máy bay, giống như thế giới thực!

