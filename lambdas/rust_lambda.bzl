""" Macro to compile and package AWS Lambdas defined in Rust """

load("@rules_rust//rust:defs.bzl", "rust_binary")
load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")

def rust_lambda(name, srcs, arch = "aarch64", visibility = "//visibility:private", **kwargs):
    """Compiles and packages an AWS Lambda written in Rust

    The macro expands to these targets:
    * [name] - the Rust binary for the host platform
    * [name]_packaged - the packaged binary for the selected AWS Lambda platform, outputting [name].zip

    Args:
        name: A name for the target
        srcs: The Rust source files
        arch: The target architecture for the Lambda, x86_64 or aarch64 (the default)
        visibility: The visibility of the target for the packaged lambda (defaults to private)
        **kwargs: additional named parameters passed to rust_binary
    """
    rust_binary(
        name = name,
        srcs = srcs,
        visibility = visibility,
        **kwargs
    )

    platform = "@rules_lambda//lambdas/platform:lambda_aarch64"
    if arch == "x86_64":
        platform = "@rules_lambda//lambdas/platform:lambda_x64_86"
    elif arch != "aarch64":
        fail("Unsupported Lambda target architecture ", arch)

    target_name = name + "_lambda"
    platform_transition_filegroup(
        name = target_name,
        srcs = [name],
        target_platform = platform,
    )
    native.genrule(
        name = name + "_packaged",
        srcs = [target_name],
        outs = [name + ".zip"],
        cmd = "cp $(execpath %s) bootstrap && zip -q -j $@ bootstrap" % target_name,
        visibility = visibility,
    )
