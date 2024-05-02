module hello::HelloSui {
  use sui::event::EventHandle;
    use sui::storage::{save_resource, borrow_global};
    use sui::framework::Object;

    struct HelloEvent has drop, store {
        message: vector<u8>,
    }

    struct Greeting has key, store {
        message: vector<u8>,
    }

    public fun say_hello(account: &signer) {
        let hello_event = HelloEvent { message: b"Hello, Sui!".to_vec() };
        let event_handle = EventHandle::new<HelloEvent>(account);
        EventHandle::emit_event(&event_handle, hello_event);
        save_resource<EventHandle<HelloEvent>>(account, event_handle);

        // Save a greeting message to the account's storage
        let greeting = Greeting { message: b"Hello, Sui!".to_vec() };
        save_resource<Greeting>(account, greeting);
    }

    public(script) fun view_greeting(account_addr: address): vector<u8> {
        let greeting = borrow_global<Greeting>(account_addr);
        greeting.message
    }
}