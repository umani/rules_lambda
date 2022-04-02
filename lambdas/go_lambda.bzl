"""Macro to compile and package AWS Lambdas defined in Go"""

load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@rules_pkg//:pkg.bzl", "pkg_zip")

def go_lambda(name, srcs, arch = "aarch64", visibility = "//visibility:private", **kwargs):
    """Compiles and packages an AWS Lambda written in Go

    The macro expands to these targets:
    * [name] - the Go library for the host platform
    * [name]_binary - the Go binary for the host platform
    * [name]_packaged - the packaged binary for the selected AWS Lambda platform, outputting [name].zip

    Args:
        name: A name for the target
        srcs: The Go source files
        arch: The target architecture for the Lambda, x86_64 or aarch64 (the default)
        visibility: The visibility of the target for the packaged lambda (defaults to private)
        **kwargs: additional named parameters passed to go_library
    """
    go_library(
        name = name,
        srcs = srcs,
        visibility = visibility,
        **kwargs
    )

    goarch = "arm64"
    if arch == "x86_64":
        platform = "amd64"
    elif arch != "aarch64":
        fail("Unsupported Lambda target architecture ", arch)

    bin_name = name + "_binary"
    go_binary(
        name = bin_name,
        embed = [name],
        pure = "on",
        goos = "linux",
        goarch = goarch,
        out = "main",
        visibility = visibility,
    )

    pkg_zip(
        name = name + "_packaged",
        srcs = [bin_name],
        package_file_name = name + ".zip",
        visibility = visibility,
    )
