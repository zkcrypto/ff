lazy_static::lazy_static! {
    pub static ref CPU_SUPPORTS_ADX_INSTRUCTION: bool = is_x86_feature_detected!("adx");
}

#[link(name = "ff-derive-crypto", kind = "static")]
extern "C" {
    fn mod_mul_4w(a: &[u64; 4], b: &[u64; 4], res: &mut [u64; 4]);
}

pub fn mod_mul_4w_assign(a: &mut [u64; 4], b: &[u64; 4]) {
    let mut res = [0; 4];
    unsafe {
        mod_mul_4w(&*a, b, &mut res);
    }
    std::mem::replace(a, res);
}

#[cfg(test)]
mod tests {
    use super::*;

    use rand_core::SeedableRng;

    #[test]
    fn test_mod_mul() {
        let mut x: [u64; 4] = [
            7665858810281813592,
            16340119633057872346,
            4817051413996267933,
            2960177199463250197,
        ];
        let y: [u64; 4] = [
            12935154801682980781,
            13314970078575206070,
            2674023185838267390,
            551755778115450960,
        ];
        let exp: [u64; 4] = [
            12035708911089303301,
            16867479803567096087,
            8918020714254073494,
            3250221169924948371,
        ];

        mod_mul_4w_assign(&mut x, &y);

        assert_eq!(x[0..4], exp[0..4], "\nMod Mul error\n");
    }
}
