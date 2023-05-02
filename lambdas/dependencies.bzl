"""Helper to fetch rules_lambda dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_skylib = struct(
    version = "1.4.1",
    sha = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
)

aspect_bazel_lib = struct(
    version = "1.29.2",
    sha = "ee95bbc80f9ca219b93a8cc49fa19a2d4aa8649ddc9024f46abcdd33935753ca",
)

rules_rust = struct(
    version = "0.18.0",
    sha = "2466e5b2514772e84f9009010797b9cd4b51c1e6445bbd5b5e24848d90e6fb2e",
)

rules_pkg = struct(
    version = "0.8.1",
    sha = "8c20f74bca25d2d442b327ae26768c02cf3c99e93fad0381f32be9aab1967675",
)

rules_go = struct(
    version = "0.34.0",
    sha = "16e9fca53ed6bd4ff4ad76facc9b7b651a89db1689a2877d6fd7b82aa824e366",
)

bazel_zig_cc = struct(
    version = "1.0.1",
    sha = "e9f82bfb74b3df5ca0e67f4d4989e7f1f7ce3386c295fd7fda881ab91f83e509",
)

# WARNING: any changes in these macros may be BREAKING CHANGES for users
# if they load us before their conflicting dependencies.

def rules_lambda_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = bazel_skylib.sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib-{}.tar.gz".format(
                bazel_skylib.version,
                bazel_skylib.version,
            ),
            "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib-{}.tar.gz".format(
                bazel_skylib.version,
                bazel_skylib.version,
            ),
        ],
    )

    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/{}/rules_pkg-{}.tar.gz".format(
                rules_pkg.version,
                rules_pkg.version,
            ),
            "https://github.com/bazelbuild/rules_pkg/releases/download/{}/rules_pkg-{}.tar.gz".format(
                rules_pkg.version,
                rules_pkg.version,
            ),
        ],
        sha256 = rules_pkg.sha,
    )

    maybe(
        http_archive,
        name = "bazel-zig-cc",
        strip_prefix = "bazel-zig-cc-v{}".format(bazel_zig_cc.version),
        urls = [
            "https://github.com/uber/hermetic_cc_toolchain/releases/download/v{}/v{}.tar.gz".format(
                bazel_zig_cc.version,
                bazel_zig_cc.version,
            ),
        ],
        sha256 = bazel_zig_cc.sha,
    )

def rust_lambda_dependencies():
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = aspect_bazel_lib.sha,
        strip_prefix = "bazel-lib-{}".format(aspect_bazel_lib.version),
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v{}.tar.gz".format(aspect_bazel_lib.version),
    )

    maybe(
        http_archive,
        name = "rules_rust",
        sha256 = rules_rust.sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_rust/releases/download/{}/rules_rust-v{}.tar.gz".format(
                rules_rust.version,
                rules_rust.version,
            ),
            "https://github.com/bazelbuild/rules_rust/releases/download/{}/rules_rust-v{}.tar.gz".format(
                rules_rust.version,
                rules_rust.version,
            ),
        ],
    )

def go_lambda_dependencies():
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        sha256 = rules_go.sha,
        url = "https://github.com/bazelbuild/rules_go/releases/download/v{}/rules_go-v{}.zip".format(
            rules_go.version,
            rules_go.version,
        ),
    )

def node_lambda_dependencies():
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = aspect_bazel_lib.sha,
        strip_prefix = "bazel-lib-{}".format(aspect_bazel_lib.version),
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v{}.tar.gz".format(aspect_bazel_lib.version),
    )
