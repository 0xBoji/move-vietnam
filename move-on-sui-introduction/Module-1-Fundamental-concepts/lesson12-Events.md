# Events
Module của chúng ta gần như đã hoàn thành! Bây giờ hãy thêm sự kiện. Chờ đã, nhưng sự kiện là gì? Sự kiện là một cách để module của bạn thông báo rằng điều gì đó đã xảy ra trên blockchain đến giao diện ứng dụng của bạn, có thể đang "lắng nghe" các sự kiện nhất định và thực hiện hành động khi chúng xảy ra. Nếu không có sự kiện, việc theo dõi xem vé được tạo, gia hạn hay đổi lại sẽ khó khăn hơn nhiều đối với thành phần "ngoài chuỗi" (hợp đồng thông minh được coi là "trên chuỗi"). Họ sẽ cần truy vấn kết quả cho từng giao dịch và thủ công xem xét kết quả để xem các object thay đổi như thế nào và thay đổi như thế nào. Điều này không hề dễ dàng và sự kiện có thể giúp đỡ! Ví dụ:

```move
module 0x123::ticket_module {
  use sui::clock::{Self, Clock};
  use sui::event;
  use sui::object::{Self, ID, UID};
  use sui::transfer;
  use sui::tx_context::{Self, TxContext};
 
  struct Ticket has key {
      id: UID,
      expiration_time: u64,
  }
 
  struct CreateTicketEvent has copy, drop {
     id: ID,
  }
 
  struct ClipTicketEvent has copy, drop {
     id: ID,
  }
 
   public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
     let uid = object::new(ctx);
     let id = object::uid_to_inner(&uid);
     let ticket = Ticket {
           id: uid,
           expiration_time: clock::timestamp_ms(clock),
     };
     transfer::transfer(ticket, tx_context::sender(ctx));
     event::emit(CreateTicketEvent {
         id,
     });
   }
 
  public fun clip_ticket(ticket: Ticket) {
     let Ticket { id, expiration_time: _ } = ticket;
     object::delete(id);
     event::emit(ClipTicketEvent {
        id: object::uid_to_inner(&id),
     });
  }
}
```

Để phát một sự kiện trên Sui, bạn chỉ cần làm hai điều:

1. Định nghĩa cấu trúc sự kiện như ClipTicketEvent.
2. Gọi event::emit để phát sự kiện được định nghĩa trong (1) Lưu ý rằng nếu chúng ta muốn bao gồm id object (cơ bản là một địa chỉ) trong sự kiện, chúng ta cần sử dụng object::uid_to_inner để chuyển đổi kiểu UID ban đầu thành kiểu ID. UID không thể được sao chép hoặc lưu trữ.

## Quiz

Phát hai sự kiện:

- MintEvent có id của object SuiFren mới được tạo.
- BurnEvent có id của SuiFren đang được xóa. Gợi ý: Đừng quên nhập khẩu!

```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    // Define the new events here

    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let sui_fren = SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
    }

    public fun burn(sui_fren: SuiFren) {
        let SuiFren {
            id,
            generation: _,
            birthdate: _,
            attributes: _,
        } = sui_fren;
        object::delete(id);
        // Emit event here
    }
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
    use sui::event;
    
    struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    struct MintEvent has copy, drop {
        id: ID,
    }

    struct BurnEvent has copy, drop {
        id: ID,
    }

    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
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

    public fun burn(sui_fren: SuiFren) {
        let SuiFren {
            id,
            generation: _,
            birthdate: _,
            attributes: _,
        } = sui_fren;
        object::delete(id);
        event::emit(BurnEvent {
            id: object::uid_to_inner(&id),
        });
    }
}
```

## Bonus: 

Ví dụ vui
Hãy tưởng tượng bạn đang điều hành một sân khấu âm nhạc ảo, nơi mỗi vé là một "Ticket". Khi một nghệ sĩ lớn được thông báo sẽ biểu diễn, một sự kiện "CreateTicketEvent" được phát để thông báo cho tất cả người dùng về cơ hội mua vé:

```move
module virtual_concert {
  use sui::event;
  use sui::object::{Self, ID, UID};

  struct ConcertTicket has key {
      id: UID,
      concert_date: u64,
  }

  struct AnnounceConcertEvent has copy, drop {
     id: ID,
  }

  public fun announce_concert(concert_id: UID, concert_date: u64) {
    let id = object::uid_to_inner(&concert_id);
    event::emit(AnnounceConcertEvent {
        id,
    });
  }
}
```

Ở đây, mỗi khi "AnnounceConcertEvent" được phát, người hâm mộ có thể nhanh chóng biết và sẵn sàng mua vé để không bỏ lỡ màn trình diễn của nghệ sĩ yêu thích. Sự kiện này giúp mọi người kết nối và tham gia vào sự kiện âm nhạc mà không cần phải liên tục kiểm tra các thông báo thủ công.
