# Tạo giá trị ngẫu nhiên

Để tạo giá trị ngẫu nhiên trên Aptos, bạn chỉ cần import module aptos_framework::randomness và gọi các hàm như u64_integer hoặc các hàm tương tự để tạo ra các giá trị mong muốn.

Ví dụ:

```
use aptos_framework::randomness;

entry fun lottery() {
    let lucky_number = randomness::u64_integer();
}
```

Hàm này có thể được gọi nhiều lần theo mong muốn:

```
use aptos_framework::randomness;

entry fun lottery() {
    let lucky_number = randomness::u64_integer();
    let lucky_number2 = randomness::u64_integer();
    let lucky_number3 = randomness::u64_integer();
}
```
Dev cũng có thể tạo một giá trị trong phạm vi mong muốn bằng cách gọi u64_range hoặc các hàm tương tự:

```
use aptos_framework::randomness;

entry fun lottery() {
    let lucky_number = randomness::u64_range(1, 100);
}
```

randomness::permutation cũng hữu ích để tạo ra một thứ tự ngẫu nhiên của một danh sách các phần tử:

```
use aptos_framework::randomness;

entry fun lottery() {
    let lucky_order = randomness::permutation(5);
}
```

Các giá trị được tạo ra từ module randomness được đảm bảo bởi blockchain Aptos (là một phần của thuật toán đồng thuận) là không thể bị thiên vị và không thể dự đoán được, ngay cả bởi các validator.
