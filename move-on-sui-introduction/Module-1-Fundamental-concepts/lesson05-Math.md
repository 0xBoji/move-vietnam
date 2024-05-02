# Math

Thực hiện phép toán trong Move rất dễ dàng và rất giống với các ngôn ngữ lập trình khác:

Cộng: x + y
Trừ: x - y
Nhân: x * y
Chia: x / y
Chia lấy dư: x % y
Lũy thừa: x ^ y

Lưu ý rằng đây là phép toán nguyên, nghĩa là kết quả sẽ được làm tròn xuống. Ví dụ, 5 / 2 = 2. Chúng ta sẽ học cách thực hiện phép toán phân số trong các bài học sau.

# Quiz

Viết lại giá trị mặc định của num_frens cho AdminCap sử dụng lũy thừa của 10.

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
           num_frens: 10 ^ 3,  // Sử dụng lũy thừa của 10 thay vì giá trị cụ thể 1000
       };
       transfer::share_object(admin_cap);
   }
}
```

## Context:
Trong đoạn code này, chúng ta đã thay đổi giá trị của num_frens thành 10 mũ 3, tức là 10^3, thay vì sử dụng giá trị cụ thể là 1000. Điều này làm cho code trở nên rõ ràng hơn về ý định sử dụng một giá trị cơ bản được tính toán thông qua phép lũy thừa.

## Source:
Tìm hiểu thêm về math trên sui: https://github.com/pichtranst123/sui-move-contract/tree/main/forces/sources

## Đáp án:

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
            num_frens: 10^3,
        };
        transfer::share_object(admin_cap);
    }
}
