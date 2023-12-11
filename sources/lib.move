module {{project-name}}::bank{
    use sui::object::{UID,Self};
    use sui::tx_context::{TxContext,Self};
    use sui::transfer;

    struct Bank has key {
        id: UID,
        wallets_created: u64,
        users_created: u64,
    }

    struct Wallet has key, store {
        id: UID,
        symbol: vector<u8>,
        balance: u64,
    }

    struct User has key, store {
        id: UID,
        wallet: Wallet,
        intended_address: address,
    }

    fun init(ctx: &mut TxContext) {
        let bank = Bank{
            id: object::new(ctx),
            wallets_created: 0,
            users_created: 0,
        };
        transfer::transfer(bank, tx_context::sender(ctx));
    }

    public entry fun create_wallet(bank: &mut Bank,symbol: vector<u8>, balance: u64, ctx: &mut TxContext) {
        let wallet = Wallet{id: object::new(ctx),
            symbol,
            balance,
        };
        bank.wallets_created = bank.wallets_created + 1;
        transfer::transfer(wallet, tx_context::sender(ctx));
    }
}