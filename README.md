# ff

`ff` is a finite field library written in pure Rust, with no `unsafe{}` code.

## Disclaimers

* This library does not provide constant-time guarantees. The traits enable downstream
  users to expose constant-time logic, but `#[derive(PrimeField)]` in particular does not
  generate constant-time code (even for trait methods that return constant-time-compatible
  values).

## Usage

Add the `ff` crate to your `Cargo.toml`:

```toml
[dependencies]
ff = "0.12"
```

The `ff` crate contains the `Field` and `PrimeField` traits.
See the **[documentation](https://docs.rs/ff/)** for more.

### #![derive(PrimeField)]

If you need an implementation of a prime field, this library also provides a procedural
macro that will expand into an efficient implementation of a prime field when supplied
with the modulus. `PrimeFieldGenerator` must be an element of Fp of p-1 order, that is
also quadratic nonresidue.

First, enable the `derive` crate feature:

```toml
[dependencies]
ff = { version = "0.12", features = ["derive"] }
```

And then use the macro like so:

```rust
use ff::PrimeField;

#[derive(PrimeField)]
#[PrimeFieldModulus = "52435875175126190479447740508185965837690552500527637822603658699938581184513"]
#[PrimeFieldGenerator = "7"]
#[PrimeFieldReprEndianness = "little"]
struct Fp([u64; 4]);
```

And that's it! `Fp` now implements `Field` and `PrimeField`.

### `build.rs`
Using the `derive(PrimeField)` functionality can slow down compile times. As an alternative, the
`ff` library's code generation functionality can be invoked via a build script.

First, add the dependencies:
```toml
[dependencies]
ff = { version = "0.12", features = ["derive"] }

[build-dependencies]
ff_codegen = "0.12"
```

Then write the `build.rs` file:
```rust
fn main() {
    let path = std::path::Path::new(&std::env::var("OUT_DIR").unwrap()).join("codegen.rs");
    std::fs::write(&path, ff_codegen::PrimeFieldCodegen {
        ident: "Fp",
        is_pub: false,
        modulus: "52435875175126190479447740508185965837690552500527637822603658699938581184513",
        generator: "7",
        endianness: ff_codegen::ReprEndianness::Little,
    }.to_string()).unwrap();
    println!("cargo:rerun-if-changed=build.rs");
}
```

And, finally, in the module you want to include the code in:
```rust
include!(concat!(env!("OUT_DIR"), "/codegen.rs"));
```

## Minimum Supported Rust Version

Requires Rust **1.56** or higher.

Minimum supported Rust version can be changed in the future, but it will be done with a
minor version bump.

## License

Licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
   http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.
