use core::traits::{Into, TryInto, DivRem};
use zeroable::NonZero;
use integer::u128_try_as_non_zero;
use option::OptionTrait;
use core::clone::Clone;
use alexandria_math::pow;

fn bit_length(num: u128) -> u128 {
    //It first asserts that the input num is non-negative (not null) using the assert_nn function. This ensures that the input is valid.
    assert(num >= 0, 'num must be non-negative');
    return bit_length_rec(num, 0);
}
fn bit_length_rec(num: u128, current_length: u128) -> u128 {
    // It calculates the value max by raising 2 to the power of current_length. This represents the maximum value that can be represented using current_length bits.
    let max = pow(2, current_length);
    let is_smaller = is_le(num, max - 1);
    if is_smaller == 1 {
        return current_length;
    } else {
        return bit_length_rec(num, current_length + 1);
    }
}
fn is_le(num1: u128, num2: u128) -> u128 {
    if num1 >= num2 {
        return num2;
    } else {
        return num1;
    }
}

fn all_ones(bit_length: u128) -> u128 {
    assert(bit_length >= 0, 'bit_length must be non-negative');
    let bit_length: u128 = bit_length;
    let max = pow(2, bit_length);
    return max - 1;
}

fn assert_le<T, impl TPartialOrd: PartialOrd<T>>(a: T, b: T, err_code: felt252) {
    assert(a <= b, err_code);
}

fn bitshift_left(word: u128, num_bits: u128) -> u128 {
    assert_le(word, 2 ^ 64 - 1, 'word must be less than 2^64 - 1');

    // verifies shifted bits are not above 64
    assert_le(num_bits, 64, 'num_bits must be less than 64');

    let multiplicator = pow(2, num_bits);
    let k = word * multiplicator;
    let (q, r) = DivRem::div_rem(k, u128_try_as_non_zero(2 ^ 64).unwrap());
    return r;
}

