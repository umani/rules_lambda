"""
Dev dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

bazel_stardoc = struct(
    version = "0.5.3",
    sha = "3fd8fec4ddec3c670bd810904e2e33170bedfe12f90adf943508184be458c8bb",
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
