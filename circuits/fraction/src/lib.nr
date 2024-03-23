// fork from https://github.com/resurgencelabs/fraction/

use dep::std;
global MAX: Fraction = Fraction { sign: true, num: 3050913689, den: 1 };
global MIN: Fraction = Fraction { sign: false, num: 3050913689, den: 1 };
global ZERO: Fraction = Fraction { sign: true, num: 0, den: 1 };
global ONE: Fraction = Fraction { sign: true, num: 1, den: 1 };
global NEGATIVE_ONE: Fraction = Fraction { sign: false, num: 1, den: 1 };

struct Fraction {
    sign: bool,
    num: u32,
    den: u32,
}


// Create a Fraction type variable without lenghtier code
pub fn toFraction(s: bool, n: u32, d: u32) -> Fraction {
    assert (d != 0);
    let fr = Fraction {
        sign: s,
        num: n,
        den: d,
    };
    fr
}


// Swaps the numerator and denominator
pub fn invert(f: Fraction) -> Fraction {
    assert (f.num != 0);
    let fr = Fraction {
        sign: f.sign,
        num: f.den,
        den: f.num,
    };
    fr
}

// Changes the Sign of the Fraction
pub fn sign(f: Fraction) -> Fraction {
    let fr = Fraction {
        sign: !f.sign,
        num: f.num,
        den: f.den,
    };
    fr
}


// Multiplies two fractions
pub fn multiply(f1: Fraction, f2: Fraction) -> Fraction {
    let mut an = f1.num as u64;
    let mut ad = f1.den as u64;
    let mut bn = f2.num as u64;
    let mut bd = f2.den as u64;
    let mut m = f1;
    let mut n = f2;
    

    if ((an*bn > 2000000000) | (ad*bd > 2000000000)) {
        m = reduce(m);
        n = reduce(n);
    }

    an = m.num as u64;
    ad = m.den as u64;
    bn = n.num as u64;
    bd = n.den as u64;

    
    if ((an*bn > 2000000000) | (ad*bd > 2000000000)) {
        let mut c = Fraction{ sign: m.sign, num: m.num, den: n.den};
        let mut d = Fraction{ sign: n.sign, num: n.num, den: m.den};
        c = reduce(c);
        d = reduce(d);
        an = c.num as u64;
        ad = c.den as u64;
        bn = d.num as u64;
        bd = d.den as u64;
    }

    
    let mut ddd = (an*bn)/(ad*bd);
    let mut factor = 1 as u64;
    for i in 1..5 {
        if ddd*10 < 2000000000 {
            factor *= 10;
            ddd = ddd * 10;
        }
        i
    }
    
    if ((an*bn > 2000000000) | (ad*bd > 2000000000)) {
        let np = ((an*bn*factor)/(ad*bd)) as u32;
        let fr = Fraction{
            sign: (f1.sign == f2.sign),
            num: np,
            den: factor as u32,
        };
        fr
        
    }
    else {
        let fr = Fraction {
            sign: (m.sign == n.sign),
            num: m.num*n.num,
            den: m.den*n.den,
        };
        fr
        
    }
    
    
}

// Divides the first fraction by the second and outputs the quotient
pub fn divide(f1: Fraction, f2: Fraction) -> Fraction {
    assert (f2.num != 0);
    let f3 = Fraction {
        sign: f2.sign,
        num: f2.den,
        den: f2.num,
    };
    let fr = multiply(f1, f3);
    
    fr
}

// this method will only work till numerator and denominator values are under 100
// this has been set for efficiency reasons, and will be modified once the Noir team
// can implement dynamic limit for loops
pub fn reduce(f: Fraction) -> Fraction {
    let mut a = f.num;
    let mut b = f.den;
    let mut min = 0;
    let mut j = 1;
    let mut gcd = 1;
    if a > b {
        min = b;
    }
    else {
        min = a;
    }
    
    for i in 2..100{
        j = i as u32;
        if (j <= min){
            if (a%j == 0) & (b%j == 0){
                gcd = j;
            }
        }
    }
    
    
    let fr = Fraction {
        sign: f.sign,
        num: f.num/gcd,
        den: f.den/gcd,
    };
    fr
}


// Adds two fractions
pub fn add(f1: Fraction, f2: Fraction) -> Fraction {
    let mut an = f1.num as u64;
    let mut ad = f1.den as u64;
    let mut bn = f2.num as u64;
    let mut bd = f2.den as u64;
    let mut m = f1;
    let mut n = f2;

    if f1.sign == f2.sign {
       
        if ((ad*bd > 2000000000) | ((an*bd + ad*bn) > 2000000000) | ((an*bd) > 2000000000) | ((ad*bn) > 2000000000)){
            m = reduce(m);
            n = reduce(n);
        }
        an = m.num as u64;
        ad = m.den as u64;
        bn = n.num as u64;
        bd = n.den as u64;
        if ((ad*bd > 2000000000) | ((an*bd + ad*bn) > 2000000000) | ((an*bd) > 2000000000) | ((ad*bn) > 2000000000)){
            let mut ddd = (an*bd + ad*bn)/(ad*bd);
            let mut factor = 1 as u64;
            for i in 1..5{
                if ddd*10 < 2000000000 {
                    ddd *= 10;
                    factor *= 10;
                }
                i
            }
            let np = (((an*bd + ad*bn)*factor)/(ad*bd)) as u32;
            let fr = Fraction {
                sign: f1.sign,
                num: np,
                den: factor as u32, 
            };
            fr
        }
        else {
            let fr = Fraction {
                sign: f1.sign,
                num: (m.num*n.den + n.num*m.den),
                den: m.den*n.den,
            };
            fr
        }
        
        
    }
    else {

        if ((an*bd) > (bn*ad)){
            if ((ad*bd > 2000000000) | ((an*bd - ad*bn) > 2000000000) | ((an*bd) > 2000000000)){
                m = reduce(m);
                n = reduce(n);
            }
            an = m.num as u64;
            ad = m.den as u64;
            bn = n.num as u64;
            bd = n.den as u64;
            if ((ad*bd > 2000000000) | ((an*bd - ad*bn) > 2000000000) | ((an*bd) > 2000000000)){
                let mut ddd = (an*bd - ad*bn)/(ad*bd);
                let mut factor = 1 as u64;
                for i in 1..5{
                    if ddd*10 < 2000000000 {
                        ddd *= 10;
                        factor *= 10;
                    }
                    i
                }
                let np = (((an*bd - ad*bn)*factor)/(ad*bd)) as u32;
                let fr = Fraction {
                    sign: f1.sign,
                    num: np,
                    den: factor as u32, 
                };
                fr
            }
            else {
                let fr = Fraction {
                    sign: f1.sign,
                    num: (m.num*n.den - n.num*m.den),
                    den: m.den*n.den,
                };
                fr
            }
        }
        else {
            if ((ad*bd > 2000000000) | ((bn*ad - bd*an) > 2000000000) | ((bn*ad) > 2000000000)){
                m = reduce(m);
                n = reduce(n);
            }
            an = m.num as u64;
            ad = m.den as u64;
            bn = n.num as u64;
            bd = n.den as u64;
            if ((ad*bd > 2000000000) | ((bn*ad - bd*an) > 2000000000) | ((bn*ad) > 2000000000)){
                let mut ddd = (bn*ad - bd*an)/(ad*bd);
                let mut factor = 1 as u64;
                for i in 1..5{
                    if ddd*10 < 2000000000 {
                        ddd *= 10;
                        factor *= 10;
                    }
                    i
                }
                let np = (((bn*ad - bd*an)*factor)/(ad*bd)) as u32;
                let fr = Fraction {
                    sign: f2.sign,
                    num: np,
                    den: factor as u32, 
                };
                fr
            }
            else {
                let fr = Fraction {
                    sign: f2.sign,
                    num: (n.num*m.den - m.num*n.den),
                    den: m.den*n.den,
                };
                fr
            }
        }
    }
}


// Subtracts the second fraction from the first
pub fn subtract(f1: Fraction, f2: Fraction) -> Fraction {
    let f3 = Fraction {
        sign: !f2.sign,
        num: f2.num,
        den: f2.den,
    };
    let fr = add(f1, f3);
    
    fr
}





// if a > b return 1
// if a < b return 2
// if a == b return 0
pub fn compare(f1: Fraction, f2: Fraction) -> u32 {
    if ((f1.num == f2.num) & (f1.num == 0)){
        0
    }
    else {
        if (f1.sign != f2.sign){
            if (f1.sign){
                1
            }
            else {
                2
            }
        }
        else {
            
            if ((f1.num*f2.den) > (f2.num*f1.den)){
                if (f1.sign){
                    1
                }
                else {
                    2
                }
            }
            else {
                
                if ((f1.num*f2.den) != (f2.num*f1.den)){
                    if (f1.sign){
                        2
                    }
                    else {
                        1
                    }
                }
                else {
                    0
                }
                
            }
            
        }
    }
    
}


// Multiplies a fraction by itself
pub fn square(f: Fraction) -> Fraction {
    let fr = multiply(f, f);
    fr
}


// Multiplies a fraction by itself, then again by itself
pub fn cube(f: Fraction) -> Fraction {
    let fr = Fraction {
        sign: f.sign,
        num: f.num*f.num*f.num,
        den: f.den*f.den*f.den,
    };
    fr
}

// Only a helper function for trigonometric computations
// Warning: Do NOT fork and remove the assert limits. It will crash your machine for big values
pub fn powerSmallFraction(f: Fraction, k: u8) -> Fraction {
    assert (k >= 1);
    assert (k < 10);
    assert ((f.num * 7) <= (11 * f.den));
    let mut n = U128::from_integer(f.num);
    let mut d = U128::from_integer(f.den);
    let p = U128::from_integer(10000);
    let z = U128::from_integer(0);
    if f.den > 10000 {
        n = (n*p)/d;
        d = p;
    }
    if n == z {
        let fr = Fraction {
            sign: true,
            num: 0,
            den: 1,
        };
        fr
    }
    else {
        let mut nprod = U128::from_integer(1);
        let mut dprod = U128::from_integer(1);

        let mut s = true;
        if ((!f.sign) & (k % 2 == 1)){
            s = false;
        }
        for i in 1..10 {
            if i as u8 <= k {
                nprod = nprod * n;
                dprod = dprod * d;
            }
        }
        let new_num = ((nprod * p) / dprod).to_integer();
        let fr = Fraction {
            sign: s,
            num: new_num,
            den: 10000,
        };
        fr

    }
}


// Adds 1 to the fraction
fn increase(f: Fraction) -> Fraction {
    let inc = Fraction {
        sign: true,
        num: 1,
        den: 1,
    };
    let fr = add(f, inc);
    fr
}


// Subtracts 1 from the fraction
pub fn decrease(f: Fraction) -> Fraction {
    let dec = Fraction {
        sign: true,
        num: 1,
        den: 1,
    };
    let fr = subtract(f, dec);
    fr
}


// Returns true if the fraction can be represented as an Integer
pub fn isInteger(f: Fraction) -> bool {
    if f.num == 0 {
        true
    }
    else {
        if (f.num % f.den == 0) {
            true
        }
        else {
            false
        }
    }
    
}


// Returns true if the fraction can NOT be represented as an Integer
pub fn isNotInteger(f: Fraction) -> bool {
    if f.num == 0 {
        false
    }
    else {
        if (f.num % f.den == 0) {
            false
        }
        else {
            true
        }
    }
    
}


// Returns the closest but smaller Integer to the Given Fraction, but typecast to Fraction for convenience
pub fn floor(f: Fraction) -> Fraction {
    let q = f.num/f.den;
    if (q * f.den == f.num){
        let fr = Fraction{
            sign: f.sign,
            num: f.num,
            den: f.den,
        };
        fr
    }
    else {
        if f.sign {
            let fr = Fraction{
                sign: f.sign,
                num: q,
                den: 1,
            };
            fr    
        }
        else {
            let fr = Fraction{
                sign: f.sign,
                num: q + 1,
                den: 1,
            };
            fr 
        }
        
    }
}

// Returns the closest but greater Integer to the Given Fraction, but typecast to Fraction for convenience
pub fn ceiling(f: Fraction) -> Fraction {
    let q = f.num/f.den;
    if (q * f.den == f.num){
        let fr = Fraction{
            sign: f.sign,
            num: f.num,
            den: f.den,
        };
        fr
    }
    else {
        if f.sign {
            let fr = Fraction{
                sign: f.sign,
                num: q + 1,
                den: 1,
            };
            fr    
        }
        else {
            let fr = Fraction{
                sign: f.sign,
                num: q,
                den: 1,
            };
            fr 
        }
        
    }
}


// returns the approximate square root of the Fraction
// passes refers to the number of iterations run to add more precision
// for num and den < 10000, passes = 10 is a good choice
// for num or den > 10000, passes = 15 is reasonable
// it should be noted that more passes lead to more gas usage, hence a tradeoff 
// between precision and viability is recommended 
unconstrained pub fn sqrt(x: Fraction, passes: u8) -> Fraction {
    assert((x.sign != false) | (x.num == 0));
    if x.num == 0 {
        x
    }
    else {
        let mut sqrt_approx = Fraction {
            sign: true,
            num: (x.num + 1)/2,
            den: x.den,
        };
        
        let two = U128::from_integer(2);
        let million = U128::from_integer(1000000);
        let p = U128::from_integer(x.num);
        let q = U128::from_integer(x.den);

        let mut c_init = U128::from_integer(sqrt_approx.num);
        let mut d_init = U128::from_integer(sqrt_approx.den);

        let mut c = c_init;
        let mut d = d_init;


        for i in 0..passes {
            c = (q*c_init*c_init + p*d_init*d_init);
            d = two*q*c_init*d_init;
            c_init = (c*million)/d;
            d_init = million;
            i
        }

        let num = c_init.to_integer();

        let fr = Fraction {
            sign: true,
            num: num,
            den: 1000000,
        };
        fr  
    }
    
}


// an approximation of the Sine function using the Taylor series
// since pi is not "exactly" equal to 22/7, the results are only an approximation (4 decimal digits)
pub fn sin(x: Fraction) -> Fraction {
    let max = Fraction {
        sign: true,
        num: 44,
        den: 7,
    };
    assert (compare(max, x) <= 1);
    assert (compare(x, ZERO) <= 1);
    let mut f = x;
    let mut flag = true;
    let quart = Fraction {
        sign: true,
        num: 11,
        den: 7,
    };
    let mid = Fraction {
        sign: true,
        num: 22,
        den: 7,
    };
    let th_quart = Fraction {
        sign: true,
        num: 33,
        den: 7,
    };
    if (compare(max, x) <= 1){
        f = subtract(max, x);
        flag = false;
    }
    if (compare(th_quart, x) <= 1){
        let f2 = subtract(th_quart, x);
        f = subtract(quart, f2);
        flag = false;
    }
    if (compare(mid, x) <= 1){
        f = subtract(mid, x);
        flag = true;
    }
    if (compare(quart, x) <= 1){
        f = x;
        flag = true;
    }
    let mut sum = ZERO;
    
    let t1 = f;
    let t2 = divide(powerSmallFraction(f, 3), toFraction(true, 6, 1));
    let t3 = divide(powerSmallFraction(f, 5), toFraction(true, 120, 1));
    let t4 = divide(powerSmallFraction(f, 7), toFraction(true, 5040, 1));
    let t5 = divide(powerSmallFraction(f, 9), toFraction(true, 362880, 1));

    let s1 = add(add(t3, t5), t1);
    let s2 = add(t2, t4);

    sum = subtract(s1, s2);

    

    if (flag != sum.sign) {
        sum = sign(sum);
    }
    if sum.num == 0 {
        sum.sign = true;
    }
    sum
}


// an approximation of the Cosine function using the Taylor series
// since pi is not "exactly" equal to 22/7, the results are only an approximation (4 decimal digits)
pub fn cos(x: Fraction) -> Fraction {
    let max = Fraction {
        sign: true,
        num: 44,
        den: 7,
    };
    assert (compare(max, x) <= 1);
    assert (compare(x, ZERO) <= 1);
    let mut f = x;
    let mut flag = true;
    let quart = Fraction {
        sign: true,
        num: 11,
        den: 7,
    };
    let mid = Fraction {
        sign: true,
        num: 22,
        den: 7,
    };
    let th_quart = Fraction {
        sign: true,
        num: 33,
        den: 7,
    };
    if (compare(max, x) <= 1){
        f = subtract(max, x);
        flag = true;
    }
    if (compare(th_quart, x) <= 1){
        let f2 = subtract(th_quart, x);
        f = subtract(quart, f2);
        flag = false;
    }
    if (compare(mid, x) <= 1){
        f = subtract(mid, x);
        flag = false;
    }
    if (compare(quart, x) <= 1){
        f = x;
        flag = true;
    }
    
    let mut sum = ONE;
   
    let t1 = toFraction(true, 1, 1);
    let t2 = divide(powerSmallFraction(f, 2), toFraction(true, 2, 1));
    let t3 = divide(powerSmallFraction(f, 4), toFraction(true, 24, 1));
    let t4 = divide(powerSmallFraction(f, 6), toFraction(true, 720, 1));
    let t5 = divide(powerSmallFraction(f, 8), toFraction(true, 40320, 1));

    let s1 = add(add(t3, t1), t5);
    let s2 = add(t2, t4);

    sum = subtract(s1, s2);

    
    
    if (flag != sum.sign){
        sum = sign(sum);
    }
    if sum.num == 0 {
        sum.sign = true;
    }
    sum
}


#[test]
fn test_sum() {
    let f1 = toFraction(true, 3, 5);
    let f2 = toFraction(true, 2, 5);
    let f = add(f1, f2);
    assert (f.num == f.den);
}

#[test]
fn test_sum_negative() {
    let f1 = toFraction(true, 3, 5);
    let f2 = toFraction(false, 1, 5);
    let f = add(f1, f2);
    let cmp = compare(f, toFraction(true, 2,5));
    assert (cmp == 0);
    
}

#[test]
fn test_diff() {
    let f1 = toFraction(true, 3, 5);
    let f2 = toFraction(true, 2, 5);
    let f = subtract(f1, f2);
    let cmp = compare(f, toFraction(true, 1,5));
    assert (cmp == 0);
    
}

#[test]
fn test_mul() {
    let f1 = toFraction(true, 1, 5);
    let f2 = toFraction(true, 5, 1);
    let f = multiply(f1, f2);
    assert (f.num == f.den);
}

#[test]
fn test_inv() {
    let f1 = toFraction(false, 1, 5);
    let f2 = invert(f1);
    let f = multiply(f1, f2);
    assert (f.num == f.den);
    
}


#[test]
fn test_div() {
    let f1 = toFraction(true, 6, 5);
    let f2 = toFraction(true, 5, 1);
    let f = divide(f1, f2);
    assert (f.num == 6);
    assert (f.den == 25);
}

#[test]
fn test_not_integer() {
    let f1 = toFraction(false, 1, 5);
    
    let is_int = isInteger(f1);

    assert (!is_int);
    
}

#[test]
fn test_integer() {
    let f1 = toFraction(false, 10, 5);
    
    let is_int = isInteger(f1);

    assert (is_int);
    
}

#[test]
fn test_square() {
    let f1 = toFraction(true, 4, 5);
    
    let f = square(f1);

    assert (f.num == 16);
    
}

#[test]
fn test_cube() {
    let f1 = toFraction(false, 1, 5);
    
    let f = cube(f1);

    assert (f.num == 1);
    assert (f.den == 125);
    assert (!f.sign);
    
}

#[test]
fn test_compare() {
    let f1 = toFraction(true, 4, 5);
    let f2 = toFraction(true, 8, 10);
    let cmp = compare(f1, f2);

    assert (cmp == 0);
    
}


#[test]
fn test_reduce() {
    let f1 = toFraction(true, 2, 10);
    let f2 = reduce(f1);

    assert (f2.num == 1);
    
}

#[test]
fn test_zero_neutrality() {
    let f1 = toFraction(true, 0, 5);
    let f2 = toFraction(false, 0, 10);
    let cmp = compare(f1, f2);

    assert (cmp == 0);
    
}

#[test]
fn test_floor() {
    let f = toFraction(true, 7, 5);
    let fl = floor(f);
    assert (fl.num == 1);
    assert (fl.den == 1);
}

#[test]
fn test_floor2() {
    let f = toFraction(false, 12, 5);
    let fl = floor(f);
    assert (fl.num == 3);
    assert (fl.den == 1);
}


#[test]
fn test_ceiling() {
    let f = toFraction(true, 7, 5);
    let ce = ceiling(f);
    assert (ce.num == 2);
    assert (ce.den == 1);
}

#[test]
fn test_ceiling2() {
    let f = toFraction(false, 12, 5);
    let ce = ceiling(f);
    assert (ce.num == 2);
    assert (ce.den == 1);
}

#[test]
fn test_globals() {
    let o = ONE;
    let no = NEGATIVE_ONE;
    let z = ZERO;
    let a = add(o , no);
    assert (a.num == z.num);
}


#[test]
fn test_mul_large() {
    let f1 = toFraction(true, 33333333, 5);
    let f2 = toFraction(true, 500000, 77777);
    let m = multiply(f1, f2);
    
    let p = m.num;
    let q = m.den;
    let lm = p/q;
    assert (lm == 42857571);
    
}


#[test]
fn test_add_large() {
    let f1 = toFraction(true, 33333333, 5);
    let f2 = toFraction(true, 500000, 33333333);
    let a = add(f1, f2);
    
    assert (compare(floor(a), MAX) == 2);
}


#[test]
fn test_sin() {
    let f1 = toFraction(true, 11, 7);
    let res = sin(f1);
    
    let sig = res.sign;
    let mut fl = 0;
    if sig{
        fl = 1;
    }

    
    assert (fl == 1);
    assert (compare(toFraction(true, 1,1), res) <= 1); 
}

#[test]
fn test_cos() {
    let f1 = toFraction(true, 3141, 2000);
    let res = cos(f1);

    let sig = res.sign;
    let mut fl = 0;
    if sig{
        fl = 1;
    }
    
    assert (fl == 1);
    assert (compare(toFraction(true, 5, 10000), res) != 2);
    
}

#[test]
fn test_sqrt1(){
    let f1 = toFraction(true, 3, 8);
    let sqrt = sqrt(f1, 10);
    let delta = subtract(f1, square(sqrt));
    let epsilon = Fraction {
        sign: true,
        num: 1,
        den: 1000,
    };
    if !delta.sign {
        assert (compare(epsilon, sign(delta)) <= 1);
    }
    else {
        assert (compare(epsilon, delta) <= 1);
    }
    
}

#[test]
fn test_sqrt2(){
    let f1 = toFraction(true, 9999999, 444);
    let sqrt = sqrt(f1, 15);
    let delta = subtract(f1, square(sqrt));
    let epsilon = Fraction {
        sign: true,
        num: 1,
        den: 1000,
    };
    if !delta.sign {
        assert (compare(epsilon, sign(delta)) <= 1);
    }
    else {
        assert (compare(epsilon, delta) <= 1);
    }
    
}