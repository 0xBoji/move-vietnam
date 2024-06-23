# Struct abilities - key, copy, drop, store
Trong khóa học trước, chúng ta đã học về structs và cách một struct cần có khả năng key để trở thành một object:
```move
struct AdminCap has key {
    id: UID,
    num_frens: u64,
}
```

Bên cạnh khả năng key, structs còn có thể có 3 khả năng khác: store, copy và drop. Structs có thể có 1, 2, 3, hoặc cả 4 khả năng. Tuy nhiên, để một struct có một khả năng cụ thể, tất cả các trường của nó phải có cùng khả năng đó.

Khả năng `Store` cho phép một struct trở thành một phần của các struct khác. Lưu ý rằng nếu `NestedStruct` dưới đây có một trường khác là `DoubleNestedStruct`, struct đó cũng cần có khả năng store.

```struct NestedStruct has store {
    value: u64,
}

struct Container has key {
    id: UID,
    nested: NestedStruct,
}
```

Khả năng `Copy` cho phép một struct có thể được "sao chép", tức là tạo ra một instance của struct với các giá trị trường giống hệt nhau. Lưu ý rằng các struct object (những struct có khả năng key và trường id) không thể có khả năng copy vì struct UID không có khả năng copy.

```move
struct CopyableStruct has copy {
    value: u64,
}

fun copy(original: CopyableStruct) {
    let copy = original;
    original.value = 1;
    copy.value = 2;
    // Bây giờ chúng ta có hai CopyableStruct với hai giá trị khác nhau.
}
```

Khả năng `Drop` cho phép một struct có thể bị hủy ngầm ở cuối một hàm mà không cần phải "destroy":

```move
struct DroppableStruct has drop {
    value: u64,
}

fun drop_example() {
    let droppable = DroppableStruct { value: 1 };
    // Ở cuối hàm này, droppable sẽ bị hủy.
    // Chúng ta không cần phải hủy một cách tường minh:
    // let DroppableStruct { value: _ } = droppable;
}
```

Điều rất quan trọng cần nhớ là một struct chỉ có thể có một khả năng nếu TẤT CẢ các trường của nó đều có cùng khả năng đó. Nếu không nhớ điều này, các developer có thể rất bối rối khi cố gắng tạo một struct có khả năng `drop` trong khi có một trường không thể `drop`.

## Quiz

Thêm khả năng store cho `SuiFren` và định nghĩa một struct object `GiftBox` mới trong module `fren_summer` có một trường inner kiểu `SuiFren`. Struct `GiftBox` không cần khả năng store vì nó không cần trở thành một phần của bất kỳ struct nào khác.

```move
module 0x123::fren_summer {
    use sui::object::{Self, UID};
    use 0x123::sui_fren::{Self, SuiFren};

    struct GiftBox has key {
        id: UID,
        inner: SuiFren,
    }

    entry fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}

module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    use sui::event;

    friend 0x123::fren_summer;
    
    struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }
}
```

## Đáp án

```move
module 0x123::fren_summer {
    use sui::object::{Self, UID};
    use 0x123::sui_fren::{Self, SuiFren};

    struct GiftBox has key {
        id: UID,
        inner: SuiFren,
    }

    entry fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        sui_fren::mint(generation, birthdate, attributes, ctx);
    }
}

module 0x123::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use std::string::String;
    use std::vector;
    use sui::event;

    friend 0x123::fren_summer;
    
    struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }
}
```

## Ví dụ Minh Họa

Ví dụ về Khả Năng Store:

```move
struct Address has store {
    street: String,
    city: String,
}

struct User has key {
    id: UID,
    name: String,
    address: Address,
}
```
Trong ví dụ này, `Address` có khả năng `store` cho phép nó trở thành một phần của struct User.

Ví dụ về Khả Năng Copy:

```move
struct Point has copy {
    x: u64,
    y: u64,
}

fun demonstrate_copy() {
    let p1 = Point { x: 1, y: 2 };
    let p2 = p1;
    // Bây giờ p1 và p2 đều là các bản sao của Point với các giá trị giống nhau.
}
```

Ví dụ về Khả Năng Drop:

```move
struct TempData has drop {
    temp_value: u64,
}

fun demonstrate_drop() {
    let temp_data = TempData { temp_value: 42 };
    // Ở cuối hàm này, temp_data sẽ tự động bị hủy.
}
```

Các ví dụ này giúp minh họa cách các khả năng store, copy, và drop hoạt động trong thực tế.

