use core::traits::{Into, TryInto};
use option::OptionTrait;
use cairo1_mmr::helpers::{bit_length, all_ones};

#[contract]
mod MMR {
    use cairo1_mmr::helpers::{bit_length, all_ones, bitshift_left};
    use core::traits::{Into, TryInto};
    use array::ArrayTrait;
    use option::OptionTrait;

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
        assert(peaks.len() > 0, 'Should least one element');
        //If peaks_len is exactly 1, that means we have only one peak, so we just return it. 

        if peaks.len() == 1 {
            let peak = *peaks.at(0);
            return peak;
        }
        // //If peaks_len is greater than 1, we set last_peak to the first element of the peaks array.
        let mut last_peak: felt252 = *peaks.at(0);

        // //Then we start a loop, which will run peaks_len - 1 times.
        let mut i = 1;
        let len = peaks.len();
        loop {
            if i == len {
                break ();
            }
            // TODO : Q. Do we need to use pedersen? or poseidon?
            let rec = *peaks.at(i);
            last_peak = pedersen(last_peak, rec);
            i += 1;
        };
        //Finally, we return the last_peak, which is the root hash of the peaks array.
        return last_peak;
    }

    #[view]
    fn compute_root(peaks: Array<felt252>, size: felt252) -> felt252 {
        let bagged_peaks = bag_peaks(peaks);
        let root = pedersen(bagged_peaks, size);

        return root;
    }

    #[view]
    fn height(index: felt252) -> felt252 {
        //It begins by checking if the index is at least 1. If it's not, an assertion error is
        let index_u128: u128 = index.try_into().unwrap();
        assert(index_u128 > 0, 'index must be at least 1');
        let bits = bit_length(index_u128);
        let ones = all_ones(bits);
        if index_u128 == ones {
            let shifted = bitshift_left(1, bits - 1);
            let input_felt: felt252 = (index_u128 - (shifted - 1)).into();
            let rec_height = height(input_felt);
            return rec_height;
        }
        let result_felt = (bits - 1).into();
        return result_felt;
    }
}
