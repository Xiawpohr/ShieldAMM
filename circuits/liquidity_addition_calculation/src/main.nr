use dep::fraction;

#[recursive]
fn main(
    liquidity: pub u32,
    price: pub u32,
    is_quote_token: pub bool,
    amount_in: pub u32,
    amount_out: pub u32,
) {
    let f_liquidity = fraction::toFraction(true, liquidity, 10000);
    let f_price = fraction::toFraction(true, price, 10000);
    let f_amount_in = fraction::toFraction(true, amount_in, 10000);
    let f_amount_out = fraction::toFraction(true, amount_out, 10000);
    
    let f_base_reserve = fraction::sqrt(fraction::divide(f_liquidity, f_price), 10);
    let f_quote_reserve = fraction::sqrt(fraction::multiply(f_liquidity, f_price), 10);

    let mut f_reserve = f_base_reserve;
    if (is_quote_token) {
        f_reserve = f_quote_reserve;
    }

    let f_correct_amount_out = fraction::multiply(
        f_liquidity,
        fraction::decrease(
            fraction::sqrt(
                fraction::divide(
                    fraction::add(
                        f_reserve,
                        f_amount_in
                    ),
                    f_reserve
                ),
                10
            )
        )
    );

    assert(fraction::compare(f_correct_amount_out, f_amount_out) <= 1);
}

// #[test]
// fn test_main() {
//     main(1, 2);
//     // Uncomment to make test fail
//     // main(1, 1);
// }
