module marketplace::marketplace {
    use sui::object;
    use 0x1::NFT;

    struct Listing has key, store {
        nft_id: object::ID,
        price: u64,
    }

    public fun list_nft(account: &signer, nft_id: object::ID, price: u64) {
        let listing = Listing { nft_id, price };
        object::store(account, listing);
    }

    public fun buy_nft(buyer: &signer, seller: address, listing_id: object::ID) {
        let listing = object::borrow_global_mut<Listing>(listing_id, &seller);
        let nft_id = listing.nft_id;
        
        // Transfer the payment from buyer to seller
        // Assume a function `transfer_coins` exists and transfers the required amount of SUI or another token
        // transfer_coins(buyer, seller, listing.price);

        // Transfer the NFT from the seller to the buyer
        NFT::transfer_nft(seller, object::owner(buyer), nft_id);

        // Remove the listing
        object::remove_global<Listing>(listing_id, &seller);
    }
}