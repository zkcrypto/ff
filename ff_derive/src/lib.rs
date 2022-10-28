#![recursion_limit = "1024"]

extern crate proc_macro;

use num_bigint::BigUint;

/// Derive the `PrimeField` trait.
#[proc_macro_derive(
    PrimeField,
    attributes(PrimeFieldModulus, PrimeFieldGenerator, PrimeFieldReprEndianness)
)]
pub fn prime_field(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
    // Parse the type definition
    let ast: syn::DeriveInput = syn::parse(input).unwrap();

    // We're given the modulus p of the prime field
    let modulus: BigUint = fetch_attr("PrimeFieldModulus", &ast.attrs)
        .expect("Please supply a PrimeFieldModulus attribute")
        .parse()
        .expect("PrimeFieldModulus should be a number");

    // We may be provided with a generator of p - 1 order. It is required that this generator be quadratic
    // nonresidue.
    // TODO: Compute this ourselves.
    let generator: BigUint = fetch_attr("PrimeFieldGenerator", &ast.attrs)
        .expect("Please supply a PrimeFieldGenerator attribute")
        .parse()
        .expect("PrimeFieldGenerator should be a number");

    // Field element representations may be in little-endian or big-endian.
    let endianness = fetch_attr("PrimeFieldReprEndianness", &ast.attrs)
        .expect("Please supply a PrimeFieldReprEndianness attribute")
        .parse()
        .expect("PrimeFieldReprEndianness should be 'big' or 'little'");

    let limbs = ff_codegen::num_u64_limbs_needed(&modulus);

    // The struct we're deriving for must be a wrapper around `pub [u64; limbs]`.
    if let Some(err) = validate_struct(&ast, limbs) {
        return err.into();
    }

    // Return the generated impl
    ff_codegen::prime_field_impls(&ast.ident, &modulus, &generator, endianness).into()
}

/// Checks that `body` contains `pub [u64; limbs]`.
fn validate_struct(ast: &syn::DeriveInput, limbs: usize) -> Option<proc_macro2::TokenStream> {
    // The body should be a struct.
    let variant_data = match &ast.data {
        syn::Data::Struct(x) => x,
        _ => {
            return Some(
                syn::Error::new_spanned(ast, "PrimeField derive only works for structs.")
                    .to_compile_error(),
            )
        }
    };

    // The struct should contain a single unnamed field.
    let fields = match &variant_data.fields {
        syn::Fields::Unnamed(x) if x.unnamed.len() == 1 => x,
        _ => {
            return Some(
                syn::Error::new_spanned(
                    &ast.ident,
                    format!(
                        "The struct must contain an array of limbs. Change this to `{}([u64; {}])`",
                        ast.ident, limbs,
                    ),
                )
                .to_compile_error(),
            )
        }
    };
    let field = &fields.unnamed[0];

    // The field should be an array.
    let arr = match &field.ty {
        syn::Type::Array(x) => x,
        _ => {
            return Some(
                syn::Error::new_spanned(
                    field,
                    format!(
                        "The inner field must be an array of limbs. Change this to `[u64; {}]`",
                        limbs,
                    ),
                )
                .to_compile_error(),
            )
        }
    };

    // The array's element type should be `u64`.
    if match arr.elem.as_ref() {
        syn::Type::Path(path) => path
            .path
            .get_ident()
            .map(|x| x.to_string() != "u64")
            .unwrap_or(true),
        _ => true,
    } {
        return Some(
            syn::Error::new_spanned(
                arr,
                format!(
                    "PrimeField derive requires 64-bit limbs. Change this to `[u64; {}]",
                    limbs
                ),
            )
            .to_compile_error(),
        );
    }

    // The array's length should be a literal int equal to `limbs`.
    let expr_lit = match &arr.len {
        syn::Expr::Lit(expr_lit) => Some(&expr_lit.lit),
        syn::Expr::Group(expr_group) => match &*expr_group.expr {
            syn::Expr::Lit(expr_lit) => Some(&expr_lit.lit),
            _ => None,
        },
        _ => None,
    };
    let lit_int = match match expr_lit {
        Some(syn::Lit::Int(lit_int)) => Some(lit_int),
        _ => None,
    } {
        Some(x) => x,
        _ => {
            return Some(
                syn::Error::new_spanned(
                    arr,
                    format!("To derive PrimeField, change this to `[u64; {}]`.", limbs),
                )
                .to_compile_error(),
            )
        }
    };
    if lit_int.base10_digits() != limbs.to_string() {
        return Some(
            syn::Error::new_spanned(
                lit_int,
                format!("The given modulus requires {} limbs.", limbs),
            )
            .to_compile_error(),
        );
    }

    // The field should not be public.
    match &field.vis {
        syn::Visibility::Inherited => (),
        _ => {
            return Some(
                syn::Error::new_spanned(&field.vis, "Field must not be public.").to_compile_error(),
            )
        }
    }

    // Valid!
    None
}

/// Fetch an attribute string from the derived struct.
fn fetch_attr(name: &str, attrs: &[syn::Attribute]) -> Option<String> {
    for attr in attrs {
        if let Ok(meta) = attr.parse_meta() {
            match meta {
                syn::Meta::NameValue(nv) => {
                    if nv.path.get_ident().map(|i| i.to_string()) == Some(name.to_string()) {
                        match nv.lit {
                            syn::Lit::Str(ref s) => return Some(s.value()),
                            _ => {
                                panic!("attribute {} should be a string", name);
                            }
                        }
                    }
                }
                _ => {
                    panic!("attribute {} should be a string", name);
                }
            }
        }
    }

    None
}
