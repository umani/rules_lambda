"""Helper to fetch rules_lambda dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_skylib_version = "1.2.1"
bazel_skylib_sha = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728"

aspect_bazel_lib_version = "0.8.2"
aspect_bazel_lib_sha = "cd818c793f2d1fc9ae3ca2cbe90b5affd54db4a5ed1f1543831b78c7f14938c5"

rules_rust_version = "0.2.0"
rules_rust_sha = "39655ab175e3c6b979f362f55f58085528f1647957b0e9b3a07f81d8a9c3ea0a"

rules_pkg_version = "0.7.0"
rules_pkg_sha = "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2"

rules_go_version = "0.31.0"
rules_go_sha = "f2dcd210c7095febe54b804bb1cd3a58fe8435a909db2ec04e31542631cf715c"

# WARNING: any changes in these macros may be BREAKING CHANGES for users
# if they load us before their conflicting dependencies.

def rules_lambda_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = bazel_skylib_sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib-{}.tar.gz".format(
                bazel_skylib_version,
                bazel_skylib_version,
            ),
            "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib-{}.tar.gz".format(
                bazel_skylib_version,
                bazel_skylib_version,
            ),
        ],
    )

    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/{}/rules_pkg-{}.tar.gz".format(
                rules_pkg_version,
                rules_pkg_version,
            ),
            "https://github.com/bazelbuild/rules_pkg/releases/download/{}/rules_pkg-{}.tar.gz".format(
                rules_pkg_version,
                rules_pkg_version,
            ),
        ],
        sha256 = rules_pkg_sha,
    )

def rust_lambda_dependencies():
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = aspect_bazel_lib_sha,
        strip_prefix = "bazel-lib-{}".format(aspect_bazel_lib_version),
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v{}.tar.gz".format(aspect_bazel_lib_version),
    )

    maybe(
        http_archive,
        name = "rules_rust",
        sha256 = rules_rust_sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_rust/releases/download/{}/rules_rust-v{}.tar.gz".format(
                rules_rust_version,
                rules_rust_version,
            ),
            "https://github.com/bazelbuild/rules_rust/releases/download/{}/rules_rust-v{}.tar.gz".format(
                rules_rust_version,
                rules_rust_version,
            ),
        ],
    )

def go_lambda_dependencies():
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        sha256 = rules_go_sha,
        url = "https://github.com/bazelbuild/rules_go/releases/download/v{}/rules_go-v{}.zip".format(
            rules_go_version,
            rules_go_version,
        ),
    )

def node_lambda_dependencies():
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = aspect_bazel_lib_sha,
        strip_prefix = "bazel-lib-{}".format(aspect_bazel_lib_version),
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v{}.tar.gz".format(aspect_bazel_lib_version),
    )
