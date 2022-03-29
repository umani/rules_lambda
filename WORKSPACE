workspace(name = "rules_lambda")

load("//:internal_dependencies.bzl", "rules_lambda_internal_dependencies")

rules_lambda_internal_dependencies()

load("//lambdas:dependencies.bzl", "rules_lambda_dependencies")

rules_lambda_dependencies()

load("//lambdas/toolchains:zig_repositories.bzl", "zig_register_toolchains")

zig_register_toolchains(
    register = ["aarch64-linux-gnu"],
)

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains", "rust_repository_set")

rules_rust_dependencies()

rust_register_toolchains(
    edition = "2021",
    extra_target_triples = [],
    version = "1.59.0",
)

rust_repository_set(
    name = "linux_lambda_tuple",
    edition = "2021",
    exec_triple = "x86_64-apple-darwin",
    extra_target_triples = ["aarch64-unknown-linux-gnu"],
    version = "1.59.0",
)
