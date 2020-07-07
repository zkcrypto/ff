#[cfg(target_arch = "x86_64")]
fn main() {
    let target_arch = std::env::var("CARGO_CFG_TARGET_ARCH").unwrap();

    if target_arch == "x86_64" {
        cc::Build::new()
            .flag("-c")
            .file("./asm/mul_4.S")
            .compile("libff-derive-crypto.a");
    }
}

#[cfg(not(target_arch = "x86_64"))]
fn main() {}
