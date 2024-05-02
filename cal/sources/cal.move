module cal::cal {
    use std::debug;

    public fun calculate_sum(a: u64, b: u64) {
        let sum = a + b;

        // Log the result using `std::debug::print`. Note that this is primarily for debugging purposes
        // and might not be suitable for production use in real-world contracts, as it's more for developer insights.
        debug::print(&sum);
    }
}