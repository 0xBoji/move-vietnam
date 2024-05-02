# Reading Object fields

Trước đây, chúng ta đã viết một ứng dụng vé đơn giản tạo ra các vé có thời hạn sử dụng. Hãy giới thiệu một hàm riêng biệt để đọc trường thời hạn sử dụng này và kiểm tra xem vé có hết hạn không:

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
 
  public fun is_expired(ticket: &Ticket, clock: &Clock): bool {
     ticket.expiration_time >= clock::timestamp_ms(clock)
  }
}
```
Để đọc dữ liệu của một object Vé, hàm `is_expired` ở trên lấy một tham chiếu bất biến đến object Vé. Move phân biệt giữa tham chiếu và giá trị object. Khi chúng ta chỉ cần đọc trạng thái của các vé hiện có trong `is_expired`, chúng ta sử dụng một tham chiếu và không nên tái tạo hoặc sao chép toàn bộ vé. Điều này tương tự như một vé điện tử, nơi bạn có thể có nhiều bản sao trên điện thoại và máy tính xách tay của mình, nhưng tất cả chúng đều chỉ đến cùng một vé. Tham chiếu bất biến có nghĩa là bạn không thể cập nhật các trường của các struct liên quan và có thể được biểu diễn với kiểu &StructName. Lưu ý rằng `is_expired` cũng lấy một tham chiếu object Đồng hồ (&Clock). Đây là một đối số tự động khác, tương tự như TxContext được hệ thống truyền. Chúng ta sẽ đề cập thêm về điều này sau.

## Bonus
Ví dụ vui
Hãy tưởng tượng bạn đang đi xem phim và cần kiểm tra vé của mình để xác nhận nó không hết hạn trước khi vào rạp. Bạn sử dụng ứng dụng trên điện thoại, mở ứng dụng vé điện tử và kiểm tra:

```move
module 0x234::cinema_tickets {
  use sui::clock::{Self, Clock};
  use sui::object::{Self, TicketID};
  use sui::tx_context::TxContext;

  struct CinemaTicket has key {
      id: TicketID,
      show_time: u64,
  }

  public fun check_ticket_validity(ticket: &CinemaTicket, clock: &Clock): bool {
     ticket.show_time > clock::timestamp_ms(clock)
  }
}
```

Ở đây, chức năng check_ticket_validity giúp bạn xác định liệu vé xem phim của bạn có còn hạn hay không bằng cách so sánh thời gian chiếu phim với thời gian hiện tại. Nếu vé vẫn còn hạn, bạn có thể yên tâm và thưởng thức bộ phim mà không gặp trở ngại!

## Quiz

Thêm một hàm mới `get_num_frens` lấy một đối số là `admin_cap` kiểu `&AdminCap` và trả về giá trị `num_frens`.
```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx),
            num_frens: 1000,
        };
        transfer::share_object(admin_cap);
    }

    // Thêm hàm get_num_frens ở đây
    public fun get_num_frens(admin_cap: &AdminCap): u64 {
        admin_cap.num_frens
    }
}
```

Trong đoạn code trên, chúng ta đã thêm hàm `get_num_frens` vào module. Hàm này lấy một tham chiếu bất biến của object AdminCap và trả về số lượng frens từ trường `num_frens` của object đó. Hàm này hữu ích khi bạn muốn biết số lượng frens hiện tại mà một admin có thể tạo.

## Context:
Ví dụ vui:
Giả sử bạn đang phát triển một ứng dụng mạng xã hội nơi "frens" là các kết nối bạn bè. Người dùng có thể gửi yêu cầu kết bạn và xem số bạn bè hiện tại. Admin của mạng xã hội này có khả năng tạo kết nối cho người dùng mới. Để quản lý và giới hạn số lượng kết nối mà một admin có thể tạo, chúng ta sử dụng AdminCap. Các nhà phát triển có thể sử dụng hàm `get_num_frens` để theo dõi và kiểm soát việc phân phối các kết nối bạn bè trong ứng dụng.

## Đáp án:
```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;


    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx),
            num_frens: 1000,
        };
        transfer::share_object(admin_cap);
    }


    // Add function get_num_frens here
    fun get_num_frens(admin_cap: &AdminCap): u64 {
        admin_cap.num_frens
    }
}
```