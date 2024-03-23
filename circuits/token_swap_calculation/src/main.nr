use dep::fraction;

#[recursive]
fn main(
    liquidity: pub u32,
    price_from: pub u32,
    price_to: pub u32,
    is_buy: pub bool,
    amount_in: pub u32,
    amount_out: pub u32,
) {
    let f_liquidity = fraction::toFraction(true, liquidity, 10000);
    let f_price_from = fraction::toFraction(true, price_from, 10000);
    let f_price_to = fraction::toFraction(true, price_to, 10000);
    let f_amount_in = fraction::toFraction(true, amount_in, 10000);
    let f_amount_out = fraction::toFraction(true, amount_out, 10000);

    let f_base_reserve = fraction::sqrt(fraction::divide(f_liquidity, f_price_from), 10);
    let f_quote_reserve = fraction::sqrt(fraction::multiply(f_liquidity, f_price_from), 10);

    let mut f_reserve_in = f_base_reserve;
    let mut f_reserve_out = f_quote_reserve;
    if (is_buy) {
        f_reserve_in = f_quote_reserve;
        f_reserve_out = f_base_reserve;
    }

    let f_new_reserve_in = fraction::add(f_reserve_in, f_amount_in);
    let f_correct_amount_out = fraction::multiply(
        f_reserve_out,
        fraction::subtract(
            fraction::ONE,
            fraction::divide(
                f_reserve_in,
                f_new_reserve_in,
            ),
        ),
    );
    let f_new_reserve_out = fraction::subtract(f_reserve_out, f_correct_amount_out);

    let mut f_expected_price = f_price_from;
    let mut f_new_price = f_price_to;
    if (is_buy) {
        f_expected_price = fraction::divide(f_amount_in, f_amount_out);
        f_new_price = fraction::divide(f_new_reserve_in, f_new_reserve_out);
        assert(fraction::compare(f_new_price, f_price_to) <= 1);
        assert(fraction::compare(f_price_to, f_expected_price) == 1);
        assert(fraction::compare(f_expected_price, f_price_from) == 1);
    } else {
        f_expected_price = fraction::divide(f_amount_in, f_amount_out);
        f_new_price = fraction::divide(f_new_reserve_in, f_new_reserve_out);
        assert(fraction::compare(f_price_from, f_expected_price) == 1);
        assert(fraction::compare(f_expected_price, f_price_to) == 1);
        assert(fraction::compare(f_price_to, f_new_price) <= 1);
    }
}

// #[test]
// fn test_main() {
//     main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
