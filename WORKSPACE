workspace(name = "rules_lambda")

load("//:internal_dependencies.bzl", "rules_lambda_internal_dependencies")

rules_lambda_internal_dependencies()

load("//lambdas:dependencies.bzl", "go_lambda_dependencies", "node_lambda_dependencies", "rules_lambda_dependencies", "rust_lambda_dependencies")

rules_lambda_dependencies()

go_lambda_dependencies()

node_lambda_dependencies()

rust_lambda_dependencies()

load("@bazel-zig-cc//toolchain:defs.bzl", zig_toolchains = "toolchains")

zig_toolchains()

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies")

rules_rust_dependencies()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()
