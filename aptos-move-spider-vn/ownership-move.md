# Quyền sở hữu trong Move

Trong Move, quyền sở hữu được thực thi bởi borrow checker, kiểm tra rằng một tài nguyên không được sử dụng sau khi nó đã được di chuyển hoặc mượn. Move cũng có một hệ thống kiểu tuyến tính, có nghĩa là các tài nguyên chỉ có thể được tiêu thụ một lần và phải được di chuyển hoặc mượn theo một thứ tự cụ thể.
Chủ sở hữu là một phạm vi sở hữu một biến. Các biến có thể được định nghĩa trong phạm vi này (ví dụ: với từ khóa let) hoặc được truyền vào phạm vi dưới dạng đối số. Vì phạm vi duy nhất trong Move là hàm - không có cách nào khác để đưa các biến vào phạm vi.
Mỗi biến chỉ có một chủ sở hữu, có nghĩa là khi một biến được truyền vào hàm dưới dạng đối số, hàm này trở thành chủ sở hữu mới, và biến không còn thuộc sở hữu của hàm đầu tiên nữa. Hoặc bạn có thể nói rằng hàm khác này nắm quyền sở hữu biến.
Di chuyển và Sao chép
Trước tiên, bạn cần hiểu cách Move VM hoạt động và điều gì xảy ra khi bạn truyền giá trị của mình vào một hàm. Có hai lệnh bytecode trong VM: MoveLoc và CopyLoc - cả hai đều có thể được sử dụng thủ công với các từ khóa move và copy tương ứng.
Khi một biến được truyền vào một hàm khác - nó đang được di chuyển và OpCode MoveLoc được sử dụng. 

Ví dụ:

```
script {
    use {{sender}}::M;

    fun main() {
        let a : Module::T = Module::create(10);

        M::value(move a); // biến a được di chuyển

        // biến cục bộ a bị hủy
    }
}
```

Đây là một mã Move hợp lệ, tuy nhiên, biết rằng giá trị vẫn sẽ được di chuyển, bạn không cần phải di chuyển nó một cách rõ ràng.
Từ khóa copy
Nếu bạn cần truyền một giá trị vào hàm (nơi nó đang được di chuyển) và lưu một bản sao của biến của bạn, bạn có thể sử dụng từ khóa copy.

```
script {
    use {{sender}}::M;

    fun main() {
        let a : Module::T = Module::create(10);

        // chúng ta sử dụng từ khóa copy để sao chép cấu trúc
        // có thể được sử dụng như `let a_copy = copy a`
        M::value(copy a);
        M::value(a); // sẽ không thất bại, a vẫn còn ở đây
    }
}
```

Trong ví dụ này, chúng ta đã truyền một bản sao của biến a vào lần gọi đầu tiên của phương thức value và lưu a trong phạm vi cục bộ để sử dụng lại trong lần gọi thứ hai.
Bằng cách sao chép một giá trị, chúng ta đã nhân đôi nó và tăng kích thước bộ nhớ của chương trình, vì vậy nó có thể được sử dụng - nhưng khi bạn sao chép dữ liệu lớn, nó có thể trở nên đắt đỏ về mặt bộ nhớ. Trong blockchain, mỗi byte đều được tính và ảnh hưởng đến giá thực thi, vì vậy việc sử dụng copy liên tục có thể khiến bạn tốn nhiều chi phí.