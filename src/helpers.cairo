use core::traits::Into;
use core::clone::Clone;
use alexandria_math::pow;

fn bit_length(num: u128) -> u128 {
    //It first asserts that the input num is non-negative (not null) using the assert_nn function. This ensures that the input is valid.
    assert(num > 0, 'num must be non-negative');
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

