use array::ArrayTrait;

#[contract]
mod MMR {
    struct Storage {
        _root: felt252,
        _last_position: felt252,
    }

    #[view]
    fn get_root() -> felt252 {
        _root::read()
    }

    #[view]
    fn get_last_position() -> felt252 {
        _last_position::read()
    }

    //  takes an array of peak hashes and "bags" them together, using a Pedersen hash function, into a single root hash.
    #[view]
    fn bag_peaks(peaks: Array<felt252>) -> felt252 {
        // checks that the length of the array of peaks is at least 1. If it's not, the program will stop with an error.
        assert(peaks.len() > 0, 'peak array must have at least one element');
        //If peaks_len is exactly 1, that means we have only one peak, so we just return it. 
        if peaks.len() == 1 {
            return peaks[0];
        }
        //If peaks_len is greater than 1, we set last_peak to the first element of the peaks array.
        let last_peak = peaks[0];
        //Then we start a loop, which will run peaks_len - 1 times.
        let i = 1;
        loop {
            if i == peaks.len() {
                break ();
            }
            // TODO : Q. Do we need to use pedersen? or poseidon?
            let rec = peaks[i];
            last_peak = pedersen(last_peak, rec);
        }
        //Finally, we return the last_peak, which is the root hash of the peaks array.
        return last_peak;
    }
}
