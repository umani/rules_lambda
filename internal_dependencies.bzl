"""
Dev dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_stardoc = struct(
    version = "0.5.2",
    sha = "05fb57bb4ad68a360470420a3b6f5317e4f722839abc5b17ec4ef8ed465aaa47",
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
