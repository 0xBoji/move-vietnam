# Updating objects
Trong bài học này, chúng ta sẽ học cách chỉnh sửa một object hiện có bằng cách cập nhật các trường của struct của nó. Đầu tiên, chúng ta cần nói về tham chiếu có thể thay đổi. Trong một bài học trước về đọc trường object, chúng ta đã đề cập đến tham chiếu bất biến và cách chúng ta có thể truyền chúng cho các hàm công khai khi gửi giao dịch để đọc trạng thái của một object.

Để chỉnh sửa một object, chúng ta cần sử dụng tham chiếu có thể thay đổi. Sự khác biệt trong cú pháp rất đơn giản - &mut StructName thay vì `&StructName`. Khi tương tác với blockchain Sui, người dùng có thể rõ ràng thấy từ các đối số của một hàm liệu các hàm chỉ đọc hay cũng chỉnh sửa object bằng cách kiểm tra liệu nó yêu cầu object bất biến (chỉ đọc) hay có thể thay đổi (đọc và viết).

Để viết một hàm cập nhật một object, trước tiên chúng ta cần chỉ định object được chỉnh sửa trong một hàm thông qua tham chiếu có thể thay đổi và sau đó cập nhật các trường của nó. Tất cả các object được chỉnh sửa đều tự động được lưu vào blockchain vào cuối giao dịch. Ví dụ:

```move
module 0x123::my_module {
   use std::vector;
   use sui::object::{Self, UID};
   use sui::transfer;
   use sui::tx_context::TxContext;

   struct MyObject has key {
       id: UID,
       value: u64,
   }

   fun init(ctx: &mut TxContext) {
       let my_object = MyObject {
           id: object::new(ctx),
           value: 10,
       };
       transfer::share_object(my_object);
   }

   public fun set_value(my_object: &mut MyObject, value: u64) {
       my_object.value = value;
   }
}
```
Đơn giản phải không? Bạn chỉ cần truyền một tham chiếu có thể thay đổi cho một object thay vì bất biến.

## Quiz

1. Thêm một hàm công khai mới `get_attributes` nhận một object sui_fren và trả về các thuộc tính của nó.
2. Viết một hàm công khai mới u`pdate_attributes` để cho phép thay đổi danh sách các thuộc tính của một SuiFren. Hàm này nên nhận hai đối số - object sui_fren để sửa đổi và danh sách mới của các thuộc tính.

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

    // Thêm các hàm mới ở đây
    public fun get_attributes(fren: &SuiFren): vector<String> {
        fren.attributes
    }

    public fun update_attributes(fren: &mut SuiFren, new_attributes: vector<String>) {
        fren.attributes = new_attributes;
    }
}
```

## Bonus:

Ví dụ vui
Tưởng tượng rằng bạn đang quản lý một trang web về câu lạc bộ sách nơi mỗi thành viên (SuiFren) có một danh sách các thể loại sách yêu thích (attributes). Một thành viên quyết định thay đổi sở thích của mình từ "tiểu thuyết khoa học" sang "lịch sử", và bạn cần cập nhật thông tin này trong hệ thống:

```move
module book_club {
    use std::vector;
    use std::string::String;

    struct BookFren {
        id: UID,
        favorite_genres: vector<String>,
    }

    fun change_genre(fren: &mut BookFren, new_genres: vector<String>) {
        fren.favorite_genres = new_genres;
    }
}
```

Ở đây, chức năng `change_genre` cho phép cập nhật sở thích đọc sách của thành viên, giúp họ có trải nghiệm cá nhân hóa hơn trong câu lạc bộ sách. Cả cộng đồng có thể thấy được sự linh hoạt và thích ứng của thành viên!