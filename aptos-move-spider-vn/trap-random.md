# Các cạm bẫy khi sử dụng tính ngẫu nhiên
Tấn công "Test-and-abort":

Có thể bị trap để code như sau:

```
public entry fun randomly_pick_winner() acquires Raffle {
    randomly_pick_winner_internal();
}
```

Điều này có thể gây ra vấn đề vì hàm này có thể được gọi từ các mã Move khác hoặc các script Move được thực thi như một giao dịch đơn lẻ. Điều này cho phép "gian lận" như sau:


```
script {
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
    use std::signer;

    fun main(attacker: &signer) {
        let attacker_addr = signer::address_of(attacker);
        let old_balance = coin::balance<aptos_coin::AptosCoin>(attacker_addr);
        
        raffle::raffle::randomly_pick_winner();
        
        let new_balance = coin::balance<aptos_coin::AptosCoin>(attacker_addr);
        
        if (new_balance == old_balance) {
            abort(1)
        };
    }
}
```

Như bạn có thể thấy từ ví dụ trên, người gọi có thể hủy bỏ kết quả không mong muốn (với chi phí gas tối thiểu) và tiếp tục thử cho đến khi họ trúng giải!
Giải pháp tốt nhất ở đây là làm cho tất cả các hàm trong ứng dụng của bạn liên quan đến tính ngẫu nhiên là private entry hoặc private.

Tấn công "Undergassing":

Một vấn đề khác xảy ra khi thực thi của một hàm Move phân nhánh dựa trên một giá trị ngẫu nhiên. Ví dụ, sử dụng câu lệnh if trên một giá trị ngẫu nhiên tạo ra hai đường dẫn thực thi có thể: nhánh "then" và nhánh "else". Vấn đề là các đường dẫn này có thể có chi phí gas khác nhau: một đường dẫn có thể rẻ hơn trong khi đường dẫn khác có thể đắt hơn về mặt gas.
Điều này sẽ cho phép kẻ tấn công thiên vị việc thực thi hàm bằng cách cung cấp không đủ gas cho giao dịch gọi nó, đảm bảo chỉ đường dẫn rẻ được thực thi thành công (trong khi đường dẫn đắt luôn bị hủy bỏ do hết gas).
Ví dụ về một hàm tung đồng xu dễ bị tấn công trong một trò chơi:

```
entry fun coin_toss(player: signer) {
   let player = get_player(player);
   assert!(!player.has_tossed_coin, E_COIN_ALREADY_TOSSED);

   let random_coin = randomness::u32_range(0, 2);
   if (random_coin == 0) {
       // Nếu ngửa, cho người chơi 100 đồng xu (đường dẫn gas thấp)
       award_hundred_coin(player);
   } else {
       // Nếu sấp, phạt người chơi (đường dẫn gas cao)
       lose_twenty_coins(player);
       lose_ten_health_points(player);
       lose_five_armor_points(player);
   }
   player.has_tossed_coin = true;
}
```
Blockchain Aptos đã quyết định yêu cầu đặt cọc 0.01 APT (được hoàn lại vào cuối giao dịch) để đảm bảo cuộc tấn công này không xảy ra.
