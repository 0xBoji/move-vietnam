# Aptos Coin

Coin cung cấp một framework tiêu chuẩn, an toàn về kiểu cho các token hoặc đồng xu đơn giản, có thể thay thế.
Cấu trúc:
Khả năng tái sử dụng
Một đồng xu được định nghĩa trong Move như sau:

```
struct Coin<phantom CoinType> has store {
    /// Số lượng đồng xu mà địa chỉ này có.
    value: u64,
}
```

Một Coin sử dụng CoinType để hỗ trợ khả năng tái sử dụng của framework Coin cho các Coin riêng biệt. Ví dụ, Coin<A> và Coin<B> là hai đồng xu riêng biệt.
Lưu trữ toàn cục
Coin cũng hỗ trợ một tài nguyên để lưu trữ đồng xu trong bộ lưu trữ toàn cục:

```
struct CoinStore<phantom CoinType> has key {
    coin: Coin<CoinType>,
    frozen: bool,
    deposit_events: EventHandle<DepositEvent>,
    withdraw_events: EventHandle<WithdrawEvent>,
}
```

Thông tin hoặc metadata của đồng xu được lưu trữ trong bộ lưu trữ toàn cục dưới tài khoản của người tạo đồng xu:

```
struct CoinInfo<phantom CoinType> has key {
    name: string::String,
    /// Ký hiệu của đồng xu, thường là phiên bản ngắn hơn của tên.
    /// Ví dụ, Đô la Singapore là SGD.
    symbol: string::String,
    /// Số thập phân được sử dụng để hiển thị cho người dùng.
    /// Ví dụ, nếu `decimals` bằng `2`, số dư `505` đồng xu nên
    /// được hiển thị cho người dùng là `5.05` (`505 / 10 ** 2`).
    decimals: u8,
    /// Số lượng loại đồng xu này đang tồn tại.
    supply: Option<OptionalAggregator>,
}
```
