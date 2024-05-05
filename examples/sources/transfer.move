module transfer::contract {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self,TxContext};
    use sui::transfer;
    use sui::dynamic_object_field as dof;

    struct Bank has key {
        id: UID,
        name: vector<u8>,
        balance: u128, // number - unsign integer
        accounts: vector<Account>
    }

    struct Account has key, store {
        id: UID,
        name: vector<u8>,
        balance: u128
    }

    struct Pool has key {
        id: UID,
        balance: u128
    }

    struct Card has key, store {
        id: UID,
        name: vector<u8>,
        balance: u128
    }

    // private
    fun init(ctx: &mut TxContext) {
        let bank = create_bank(ctx);
        let pool = Pool {
            id: object::new(ctx),
            balance: 0,
        };

        let pool2 = Pool {
            id: object::new(ctx),
            balance: 0,
        };

        transfer::share_object(pool);
        transfer::freeze_object(pool2);
        transfer::transfer(bank, tx_context::sender(ctx));
    }

    public fun create_bank(ctx: &mut TxContext): Bank {
        Bank {
            id: object::new(ctx),
            name: b"VBI Bank",
            balance: 1_000_000_000_000,
            accounts: vector[],
        }
    }

    public entry fun create_account(_: &Bank, name: vector<u8>, receipt: address, ctx: &mut TxContext) {
        let account = Account {
            id: object::new(ctx),
            name,
            balance: 0,
        };

        transfer::transfer(account, receipt);
    }

    public entry fun increament_balance(account: &mut Account, amount: u128) {
        account.balance + amount;
    }

    public entry fun view_balance(account: &Account): u128 {
        account.balance
    }

    public entry fun delete_account(account: Account) {
        let Account {id, name: _, balance: _} = account;
        object::delete(id);
    }
}
    public entry fun add_dof(name: vector<u8>, account: &mut Account,ctx: &mut TxContext) {
        let card = Card {
            id: object::new(ctx),
            name,
            balance: 0
        };

        dof::add(&mut account.id, b"Master Card", card);
    }