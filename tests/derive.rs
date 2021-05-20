//! This module exercises the `ff_derive` procedural macros, to ensure that changes to the
//! `ff` crate are reflected in `ff_derive`.

#[macro_use]
extern crate ff;

/// The BLS12-381 scalar field.
#[derive(PrimeField)]
#[PrimeFieldModulus = "52435875175126190479447740508185965837690552500527637822603658699938581184513"]
#[PrimeFieldGenerator = "7"]
#[PrimeFieldReprEndianness = "little"]
struct Bls381K12Scalar([u64; 4]);

mod fermat {
    /// The largest known Fermat prime, used to test the case `t = 1`.
    #[derive(PrimeField)]
    #[PrimeFieldModulus = "65537"]
    #[PrimeFieldGenerator = "3"]
    #[PrimeFieldReprEndianness = "little"]
    struct Fermat65537Field([u64; 1]);
}
