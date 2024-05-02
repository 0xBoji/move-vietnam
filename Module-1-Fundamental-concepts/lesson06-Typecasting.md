# Typecasting

Trong bài học trước, chúng ta đã thấy các loại số nguyên khác nhau: u8, u32, u64, u128, u256. Mặc dù phép toán có thể được thực hiện dễ dàng giữa các số nguyên cùng loại, nhưng không thể thực hiện trực tiếp phép toán giữa các số nguyên của các loại khác nhau:

```move
fun mixed_types_math(): u64 {
   let x: u8 = 1;
   let y: u64 = 2;
   // Phép toán này sẽ không biên dịch được vì x và y là các loại khác nhau. Một là u8, cái kia là u64.
   x + y
}
```

Để sửa lỗi này, chúng ta cần ép kiểu x thành u64 bằng cách sử dụng (x as u64). Hãy nhớ rằng dấu ngoặc đơn () là bắt buộc khi ép kiểu.

```move
fun mixed_types_math(): u64 {
   let x: u8 = 1;
   let y: u64 = 2;
   // Điều này sẽ không biên dịch được vì x và y là các loại khác nhau. Một là u8, cái kia là u64.
   (x as u64) + y
}
```

## Quiz
Hàm init dưới đây hiện đang thiết lập num_frens trong AdminCap thành một hằng số (giá trị cố định) DEFAULT_NUM_FRIENDS kiểu u16 mặc dù num_frens là kiểu u64. Điều này sẽ không biên dịch được do không khớp kiểu. Sửa lỗi này.

```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    const DEFAULT_NUM_FRIENDS: u16 = 1000;

    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    fun init(ctx: &mut TxContext) {
        let config = AdminCap {
            id: object::new(ctx),
            num_frens: DEFAULT_NUM_FRIENDS,
        };
        transfer::share_object(config);
    }
}
```

## Đáp án:
```move
module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    const DEFAULT_NUM_FRIENDS: u16 = 1000;

    struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    
    fun init(ctx: &mut TxContext) {
        let config = AdminCap {
            id: object::new(ctx),
            num_frens: (DEFAULT_NUM_FRIENDS as u64),
        };
        transfer::share_object(config);
    }
}
```

## Bonus:
Ví dụ vui: 

Giả sử bạn đang code một chiếc máy bán kẹo tự động, nơi bạn cần tính toán tổng số kẹo còn lại sau khi một khách hàng mua kẹo. Khách hàng đưa vào một đồng xu 100 đồng (kiểu u8 vì máy chỉ nhận những đồng xu dưới 255 đồng) và bạn muốn trừ số tiền này từ tổng tiền trong máy (kiểu u64 vì máy (pool) có thể chứa rất nhiều tiền). Đây là cách bạn có thể xử lý điều này:

```move
module candy_machine {
    fun process_payment(coin: u8, total_money: u64): u64 {
        (coin as u64) - total_money
    }
}

```

Ở đây, chúng ta phải ép kiểu `coin` từ u8 sang u64 trước khi thực hiện phép trừ, để đảm bảo rằng các kiểu dữ liệu phù hợp và tránh lỗi biên dịch.
