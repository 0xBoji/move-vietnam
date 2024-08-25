# Sử dụng timestamp trong Move

Module timestamp trong Move cung cấp các hàm để làm việc với thời gian. Dưới đây là một ví dụ về cách sử dụng timestamp:
```
module my_addrx::UnderstandingTimestamp {
    use std::timestamp; 
    
    public entry fun time() {
        let t1 = timestamp::now_microseconds();
        std::debug::print(&t1);
        
        let t2 = timestamp::now_seconds();
        std::debug::print(&t2);
    }
 
    #[test(framework = @0x1)]
    fun testing(framework: signer) {
        // thiết lập thời gian toàn cục cho mục đích kiểm thử
        timestamp::set_time_has_started_for_testing(&framework);   
        time(); 
    }   
}
```

Trong ví dụ này:

Hàm time() lấy thời gian hiện tại dưới dạng microseconds và seconds và in ra.
Hàm testing() là một hàm kiểm thử, nó thiết lập thời gian cho mục đích kiểm thử trước khi gọi hàm time().

Lưu ý rằng trong môi trường sản xuất thực tế, thời gian được quản lý bởi blockchain và không thể được thiết lập thủ công như trong hàm kiểm thử.