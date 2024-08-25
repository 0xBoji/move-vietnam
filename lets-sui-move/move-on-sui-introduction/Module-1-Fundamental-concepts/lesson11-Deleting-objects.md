# Deleting Objects:
<p>Trong các bài học trước, chúng ta đã bao quát hai loại đối số Đối tượng có thể được truyền vào một hàm từ giao dịch của người dùng: tham chiếu bất biến &ObjectStruct được sử dụng để đọc dữ liệu từ một đối tượng và tham chiếu có thể thay đổi &mut ObjectStruct được sử dụng để chỉnh sửa một đối tượng. Có một loại đối số đối tượng thứ ba mà chúng ta có thể truyền vào một hàm nhập - giá trị đối tượng có thể được sử dụng để xóa một đối tượng khỏi bộ nhớ Sui:</p>

```move
module 0x123::ticket_module {
  use sui::clock::{Self, Clock};
  use sui::object::{Self, UID};
  use sui::transfer;
  use sui::tx_context::TxContext;
 
  struct Ticket has key {
      id: UID,
      expiration_time: u64,
  }
 
  public fun clip_ticket(ticket: Ticket) {
     let Ticket {
         id,
         expiration_time: _,
     } = ticket;
     object::delete(id);
  }
}
```
Trong ví dụ trên, chúng ta đã thêm một hàm mới clip_ticket lấy một đối tượng Ticket làm đối số và xóa nó. Chúng ta không truyền một tham chiếu có thể thay đổi đến đối tượng vì chúng ta không chỉnh sửa nó. Thay vào đó, chúng ta truyền cả cấu trúc Ticket để có thể xóa nó:

- Phá hủy cấu trúc Ticket với let Ticket { id, expiration_time: _ } = ticket
- Hủy đối tượng Ticket với object::delete(id)

## Quiz:

Thêm một hàm công khai mới `burn` lấy và hủy một SuiFren :(

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

    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let sui_fren = SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
    }
    
    // Add the new burn function here
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

    // Add the new burn function here
    public fun burn(sui_fren: SuiFren) {
        let SuiFren {
            id,
            generation: _,
            birthdate: _,
            attributes: _,
        } = sui_fren;
        object::delete(id);
    }
}
```

## Bonus:
Ví dụ vui
Tưởng tượng bạn đang chạy một cửa hàng bánh kẹo phép thuật trong một thế giới giả tưởng, nơi mỗi chiếc kẹo là một "SuiFren" với các thuộc tính ma thuật. Một chiếc kẹo hết hạn sử dụng có thể phát nổ nếu không được xử lý đúng cách, và bạn cần phải "hủy" chúng an toàn bằng cách sử dụng một phép thuật hủy bỏ:

```move
module magic_candy_shop {
    use sui::object::{Self, UID};
    use std::vector;

    struct MagicCandy has key {
        id: UID,
        magic_properties: vector<String>,
        expiration_time: u64,
    }

    public fun dispose_expired_candy(candy: MagicCandy) {
        let now = sui::clock::now();
        if candy.expiration_time < now {
            object::delete(candy.id);
            // Phép thuật để xóa chiếc kẹo an toàn
        }
    }
}
```

Ở đây, hàm `dispose_expired_candy` giúp đảm bảo rằng không có chiếc kẹo phép thuật nào hết hạn có thể gây hại cho cửa hàng hoặc khách hàng bằng cách xóa chúng an toàn trước khi chúng trở nên nguy hiểm.

