# Objects trên Sui
Một khái niệm cơ bản trong Sui mà chúng ta cần khám phá đầu tiên là object. Trong Sui, tất cả dữ liệu được biểu diễn dưới dạng các trường bên trong các object riêng biệt. Điều này mô phỏng cuộc sống thực tế, nơi mọi thứ xung quanh chúng ta đều là một object - ghế, bàn, đèn, v.v. Con người đi qua cuộc sống bằng cách tương tác với các object, quan sát chúng để hiểu các đặc điểm, tương tác với chúng và thay đổi trạng thái của chúng.

Trong ví dụ trên, chúng ta định nghĩa một struct đơn giản là MyObject với hai trường là id và color. Mỗi struct có thể được định nghĩa là có "khả năng" - key, store, drop, copy. Chúng ta sẽ giải thích thêm sau về những khả năng này có nghĩa là gì.

Trên blockchain Sui, các module tạo, đọc, tương tác và chỉnh sửa các object như một phần của quy trình của chúng. Khi người dùng gửi giao dịch để gọi các chức năng khác nhau trên blockchain, các chức năng mà họ gọi có thể cần đọc dữ liệu từ nhiều object mà người dùng sở hữu và chỉnh sửa chúng để phản ánh kết quả của tương tác người dùng. object là một khối xây dựng cơ bản trong Sui Move và là trọng tâm của bất kỳ ứng dụng nào. Khi xây dựng một ứng dụng, điều đầu tiên các nhà phát triển nên suy nghĩ là dữ liệu ứng dụng trông như thế nào và cần tạo ra những object nào để lưu trữ chúng.

#### Ví dụ, như một phần của một ứng dụng đặt vé, người dùng có thể gọi vào một module trước tiên cấp cho bạn một vé và cho phép bạn kiểm tra xem vé có hết hạn hay không:

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

   public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
       let ticket = Ticket {
           id: object::new(ctx),
           expiration_time: clock::timestamp_ms(clock),
       };
       transfer::share_object(ticket);
   }
}
```

##### Các bước là:

1. Định nghĩa object (chúng ta sử dụng struct để biểu diễn object). Trong trường hợp này, chúng ta định nghĩa object Vé. object này phải có khả năng key và một trường `id` kiểu `object::UID` (xem câu lệnh nhập khẩu ở đầu module).
2. Gọi `object::new` với đối số mặc định `&mut TxContext` được truyền cho tất cả các chức năng khi được gọi thông qua một giao dịch. `&mut TxContext` là cần thiết để tạo một object mới để gọi `object::new`, trả về id duy nhất của object có thể được gán cho trường id của object (Vé trong trường hợp này).
3. Gọi `transfer::share_object` để làm cho object được chia sẻ. Điều này hữu ích khi dữ liệu trong object được sử dụng cho nhiều người dùng (dữ liệu toàn cầu) và không thuộc về bất kỳ người dùng cụ thể nào. Trong trường hợp này, về mặt kỹ thuật một vé không nhất thiết phải được chia sẻ nhưng chúng ta sẽ làm cho nó được chia sẻ cho mục đích minh họa. object thuộc sở hữu là các object thuộc sở hữu của một người dùng cụ thể và chỉ có thể được đọc hoặc chỉnh sửa với sự cho phép của người dùng đó (thông qua việc ký một giao dịch). Chúng ta sẽ đi sâu hơn về object chia sẻ và object thuộc sở hữu trong các bài học tiếp theo.

## Quiz

Trong bài học trước, chúng ta đã định nghĩa struct `AdminCap` nhưng nó chưa phải là một loại object hợp lệ. Hãy:
1. Cập nhật AdminCap để có khả năng key và một trường id kiểu UID.
2. Thêm một hàm riêng tư mới - fun init có đối số ctx kiểu &mut TxContext và tạo object AdminCap với num_frens được thiết lập là 1000. Hàm init được tự động gọi khi module được triển khai lên blockchain.
3. Chia sẻ object AdminCap để bất kỳ ai cũng có thể sử dụng để tạo Frens. Chúng ta sẽ giải thích sau cách làm thế nào để chỉ các tài khoản cụ thể mới có thể có AdminCap và tạo Frens.

```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};

    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }

    private fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx),
            num_frens: 1000,
        };
        transfer::share_object(admin_cap);
    }
}

```
### Context:
Trong đoạn code này, chúng ta đã thêm thuộc tính key vào struct AdminCap và thêm trường id kiểu UID, đồng thời định nghĩa một hàm init để tạo và chia sẻ object AdminCap. Hàm init này sẽ được gọi tự động khi module được triển khai, tạo điều kiện cho việc sử dụng AdminCap để tạo ra các Frens.

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
}
```
