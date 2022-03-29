"""
Starlark helper to fetch rules_lambda dependencies.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_skylib_version = "1.2.1"
bazel_skylib_sha = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728"

aspect_bazel_lib_version = "0.6.2"
aspect_bazel_lib_sha = "e1576ba9a488945ada050bf24d71700d7f792389efb9af72e5132b2db6ceb26e"

rules_rust_commit = "41b39f0c9951dfda3bd0a95df31695578dd3f5ea"
rules_rust_sha = "c9478810c5e2ab1e19bb830b1d8284736b9a6395b96ce914c8ac5ce8d1368d0d"

# WARNING: any changes in this function may be BREAKING CHANGES for users
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
        name = "aspect_bazel_lib",
        sha256 = aspect_bazel_lib_sha,
        strip_prefix = "bazel-lib-{}".format(aspect_bazel_lib_version),
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v{}.tar.gz".format(aspect_bazel_lib_version),
    )

    maybe(
        http_archive,
        name = "rules_rust",
        sha256 = rules_rust_sha,
        strip_prefix = "rules_rust-{}".format(rules_rust_commit),
        url = "https://github.com/bazelbuild/rules_rust/archive/{}.tar.gz".format(rules_rust_commit),
    )
