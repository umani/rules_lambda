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
    url = "https://github.com/duarten/rules_lambda/archive/refs/tags/${TAG}.tar.gz",
)

load("@rules_lambda//lambdas:dependencies.bzl", "rules_lambda_dependencies")

rules_lambda_dependencies()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# Optional: if using Rust lambdas, register dependencies

load("@rules_lambda//lambdas:dependencies.bzl", "rust_lambda_dependencies")

rust_lambda_dependencies()

# Optional: if cross-compiling the Rust Lambdas, set up the Zig toolchain
#			and possibly other required Rust toolchains.

load("@rules_lambda//lambdas/toolchains:zig_repositories.bzl", "zig_register_toolchains")

zig_register_toolchains(
    register = ["aarch64-linux-gnu"],
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
