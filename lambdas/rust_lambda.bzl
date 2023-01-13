"""Macro to compile and package AWS Lambdas defined in Rust"""

load("@rules_rust//rust:defs.bzl", "rust_binary")
load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")

def rust_lambda(name, srcs, arch = "aarch64", visibility = ["//visibility:private"], **kwargs):
    """Compiles and packages an AWS Lambda written in Rust.

    The macro expands to these targets:
    * `[name]` - the Rust binary for the host platform.
    * `[name]_packaged` - the packaged binary for the selected AWS Lambda platform, outputting `[name].zip`.

    Args:
        name: A unique name for this rule.
        srcs: The Rust source files.
        arch: The target architecture for the Lambda, `x86_64` or `aarch64`.
        visibility: The visibility of the `rust_binary` and packaged Lambda targets.
        **kwargs: additional named parameters passed to `rust_binary`.
    """
    rust_binary(
        name = name,
        srcs = srcs,
        visibility = visibility,
        **kwargs
    )

    platform = "@rules_lambda//lambdas/platform:lambda_aarch64"
    if arch == "x86_64":
        platform = "@rules_lambda//lambdas/platform:lambda_x86_64"
    elif arch != "aarch64":
        fail("Unsupported Lambda target architecture ", arch)

    target_name = name + "_lambda"
    platform_transition_filegroup(
        name = target_name,
        srcs = [name],
        target_platform = platform,
    )

    packaged_name = name + "_packaged_files"
    pkg_files(
        name = packaged_name,
        srcs = [target_name],
        renames = {
            target_name: "bootstrap",
        },
    )
    pkg_zip(
        name = name + "_packaged",
        srcs = [packaged_name],
        package_file_name = name + ".zip",
        visibility = visibility,
    )
