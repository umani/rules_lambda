#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

TAG=${GITHUB_REF_NAME}
PREFIX="rules_lambda-${TAG:1}"
SHA=$(git archive --format=tar --prefix=${PREFIX}/ ${TAG} | gzip | shasum -a 256 | awk '{print $1}')

cat << EOF
WORKSPACE snippet:
\`\`\`starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_lambda",
    sha256 = "${SHA}",
    strip_prefix = "${PREFIX}",
    url = "https://github.com/umani/rules_lambda/archive/refs/tags/${TAG}.tar.gz",
)

load("@rules_lambda//lambdas:dependencies.bzl", "rules_lambda_dependencies")

rules_lambda_dependencies()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# Optional: if using Go lambdas, register dependencies

load("@rules_lambda//lambdas:dependencies.bzl", "go_lambda_dependencies")

go_lambda_dependencies()

# Optional: if using Node lambdas, register dependencies

load("@rules_lambda//lambdas:dependencies.bzl", "node_lambda_dependencies")

node_lambda_dependencies()

# Optional: if using Rust lambdas, register dependencies

load("@rules_lambda//lambdas:dependencies.bzl", "rust_lambda_dependencies")

rust_lambda_dependencies()

# Optional: if cross-compiling the Rust Lambdas, set up the Zig toolchain
#			and possibly other required Rust toolchains.

load("@bazel-zig-cc//toolchain:defs.bzl", zig_toolchains = "toolchains")

zig_toolchains()

register_toolchains(
    "@zig_sdk//toolchain:linux_arm64_gnu.2.34",
)

# Example: cross-compiles Rust from macOS to aarch64 Linux
rust_repository_set(
    name = "aarch64_lambda_tuple",
    edition = "2021",
    exec_triple = "x86_64-apple-darwin",
    extra_target_triples = ["aarch64-unknown-linux-gnu"],
    version = "1.59.0",
)
\`\`\`
