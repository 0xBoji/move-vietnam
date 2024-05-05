module hello::hello {
    use sui::storage::{save, borrow_global};
    use sui::framework::Object;
    use sui::event::{EventHandle, emit_event};
    use sui::types::UID;

    struct HelloEvent has drop, store {
        message: vector<u8>,
    }

    struct Greeting has key, store {
        message: vector<u8>,
    }

    public fun say_hello(account: &signer, value: vector<u8>) {
        // Create and emit a HelloEvent
        let hello_event = HelloEvent { message: b"Hello, Sui!".to_vec() };
        let event_handle = EventHandle::new<HelloEvent>(UID::new(), account);
        emit_event(&event_handle, hello_event);
        save(account, event_handle);

        // Modify the greeting message based on the value received
        let greeting_message = b"hello ".to_vec();
        let mut full_message = Vector::append(greeting_message, value);
        let sui_part = b", Sui!".to_vec();
        Vector::append(&mut full_message, sui_part);

        // Save a greeting message to the account's storage
        let greeting = Greeting { message: full_message };
        save(account, greeting);
    }

    public fun view_greeting(account_addr: address): vector<u8> {
        let greeting = borrow_global<Greeting>(account_addr);
        greeting.message
    }
}
