"""
Dev dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_stardoc_version = "0.5.0"
bazel_stardoc_sha = "c9794dcc8026a30ff67cf7cf91ebe245ca294b20b071845d12c192afe243ad72"

def rules_lambda_internal_dependencies():
    maybe(
        http_archive,
        name = "io_bazel_stardoc",
        sha256 = bazel_stardoc_sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/{}/stardoc-{}.tar.gz".format(
                bazel_stardoc_version,
                bazel_stardoc_version,
            ),
            "https://github.com/bazelbuild/stardoc/releases/download/{}/stardoc-{}.tar.gz".format(
                bazel_stardoc_version,
                bazel_stardoc_version,
            ),
        ],
    )
