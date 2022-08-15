"""Helper to fetch rules_lambda dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_skylib = struct(
    version = "1.2.1",
    sha = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
)

aspect_bazel_lib = struct(
    version = "1.10.0",
    sha = "33332c0cd7b5238b5162b5177da7f45a05641f342cf6d04080b9775233900acf",
)

rules_rust = struct(
    version = "0.9.0",
    sha = "6bfe75125e74155955d8a9854a8811365e6c0f3d33ed700bc17f39e32522c822",
)

rules_pkg = struct(
    version = "0.7.0",
    sha = "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2",
)

rules_go = struct(
    version = "0.34.0",
    sha = "16e9fca53ed6bd4ff4ad76facc9b7b651a89db1689a2877d6fd7b82aa824e366",
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
