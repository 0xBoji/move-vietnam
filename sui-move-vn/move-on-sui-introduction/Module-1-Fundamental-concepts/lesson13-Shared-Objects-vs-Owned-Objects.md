# Shared Objects vs Owned Objects
Trong các lesson trước, chúng ta đã làm quen với Shared objects và Owned Objects:

```move
struct SharedObject has key {
   id: UID,
}

struct OwnedObject has key {
   id: UID,
}

public fun create_shared_object(ctx: &mut TxContext) {
 let shared_object = SharedObject {
     id: object::new(ctx),
 };
 transfer::share_object(shared_object);
}

public fun create_owned_object(ctx: &mut TxContext) {
 let owned_object = OwnedObject {
     id: object::new(ctx),
 };
 transfer::transfer(owned_object, tx_context::sender(ctx));
}
```

Một lợi ích chính của việc sử dụng Owned Objects là chúng có thể được xử lý song song vì các giao dịch chạm vào chúng không trùng lặp với nhau (chúng không đọc hoặc sửa đổi cùng một dữ liệu). Tuy nhiên, các Shared Objects không thể được xử lý song song nếu chúng bị sửa đổi và sẽ cần phải trải qua một quy trình thực thi nghiêm ngặt hơn, điều này chậm hơn và kém khả năng mở rộng hơn.

Một điều quan trọng khác cần lưu ý với Shared Objects là chúng chỉ có thể được chia sẻ trong cùng một giao dịch nơi chúng được tạo ra. Điều này sẽ không hoạt động:

```move
struct SharedObject has key {
   id: UID,
}


public fun create_object(tx_context: &mut TxContext) {
 let object = SharedObject {
     id: object::new(ctx),
 };
 transfer::transfer(object, tx_context::sender(ctx));
}


public fun share_object(object: SharedObject) {
 transfer::share_object(object);
}
```
Nếu chúng ta gọi `create_object` để tạo một object ban đầu được sở hữu và sau đó cố gắng chia sẻ nó với `share_object` trong một giao dịch thứ hai, điều này sẽ thất bại!

## Quiz

Sự khác biệt giữa Shared Objects và Owned Objects là gì?

A. Owned Objects cần phải qua quá trình đồng thuận trước khi các giao dịch sử dụng chúng được hoàn tất.
B. Shared Objects có thể được chuyển đổi thành Owned Objects nhưng không thể làm ngược lại.
C. Owned Objects có thể được chia sẻ khi chúng được tạo ra. Shared Objects không thể chuyển đổi thành Owned Objects.

## Đáp án:
C. Owned Objects có thể được chia sẻ khi chúng được tạo ra. Shared Objects không thể chuyển đổi thành Owned Objects.

## Bonus: 

Ví dụ về Shared Objects:
```move
struct SharedCounter has key {
    id: UID,
    value: u64,
}

public fun create_shared_counter(ctx: &mut TxContext): SharedCounter {
    let counter = SharedCounter {
        id: object::new(ctx),
        value: 0,
    };
    transfer::share_object(&counter);
    counter
}

public fun increment_shared_counter(counter: &mut SharedCounter) {
    counter.value = counter.value + 1;
}
```

Trong ví dụ này, SharedCounter là một đối tượng chia sẻ có thể được cập nhật bởi nhiều giao dịch khác nhau, nhưng không thể được xử lý song song nếu bị sửa đổi.

Ví dụ về Owned Objects:
```move
struct OwnedToken has key {
    id: UID,
    balance: u64,
}

public fun create_owned_token(ctx: &mut TxContext, initial_balance: u64): OwnedToken {
    let token = OwnedToken {
        id: object::new(ctx),
        balance: initial_balance,
    };
    transfer::transfer(&token, tx_context::sender(ctx));
    token
}

public fun transfer_token(token: OwnedToken, new_owner: address) {
    transfer::transfer(&token, new_owner);
}
```
rong ví dụ này, OwnedToken là một Owned Objects có thể được chuyển từ người này sang người khác, và các giao dịch sử dụng object này có thể được xử lý song song.
