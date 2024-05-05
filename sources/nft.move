module nft::nft {
    use sui::object;
    
    struct NFT has key, store {
        creator: address,
        metadata: vector<u8>,  // Metadata can include information like name, description, image URL, etc.
    }

    public fun create_nft(account: &signer, metadata: vector<u8>) {
        let nft = NFT { creator: object::owner(account), metadata };
        object::store(account, nft);
    }

    public fun transfer_nft(sender: &signer, recipient_address: address, nft_id: object::ID) {
        object::transfer(sender, recipient_address, nft_id);
    }
}