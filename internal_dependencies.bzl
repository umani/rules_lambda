"""
Dev dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_stardoc = struct(
    version = "0.5.1",
    sha = "aa814dae0ac400bbab2e8881f9915c6f47c49664bf087c409a15f90438d2c23e",
)

def rules_lambda_internal_dependencies():
    maybe(
        http_archive,
        name = "io_bazel_stardoc",
        sha256 = bazel_stardoc.sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/{}/stardoc-{}.tar.gz".format(
                bazel_stardoc.version,
                bazel_stardoc.version,
            ),
            "https://github.com/bazelbuild/stardoc/releases/download/{}/stardoc-{}.tar.gz".format(
                bazel_stardoc.version,
                bazel_stardoc.version,
            ),
        ],
    )
