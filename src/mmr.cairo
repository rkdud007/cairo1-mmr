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

    // return the last peak
    #[view]
    fn bag_peaks(peaks: Array<felt252>) -> felt252 {
        let last_position = _last_position::read();
        let mut last_peak = last_position;
        let mut i: usize = 0;
        loop {
            let position = last_position - i;
            let peak = _root::read(position);
            if peak == 0 {
                break ();
            }
            peaks.append(peak);
            last_peak = peak;
            i += 1;
        }

        peak
    }
}
