load("@bazel_skylib//lib:shell.bzl", "shell")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "read_user_netrc", "use_netrc")
load("//lambdas/toolchains:zig_toolchain.bzl", "zig_cc_toolchain_config")

# Heavily based on https://git.sr.ht/~motiejus/bazel-zig-cc

DEFAULT_TOOL_PATHS = {
    "ar": "ar",
    "gcc": "c++",  # https://github.com/bazelbuild/bazel/issues/4644
    "ld": "ld.lld",
    "cpp": "/usr/bin/false",
    "gcov": "/usr/bin/false",
    "nm": "/usr/bin/false",
    "objdump": "/usr/bin/false",
    "strip": "/usr/bin/false",
}.items()

ZIG_URL_TEMPLATE = "https://ziglang.org/download/{version}/zig-{host_platform}-{version}.tar.xz"

ZIG_NIGHTLY_URL_TEMPLATE = "https://ziglang.org/builds/zig-{host_platform}-{version}.tar.xz"

_VERSION = "0.10.0-dev.1623+0501962b4"

_SHA256 = {
    "linux-x86_64": "040406d99ef93cbbfd7855576e8afb7409161b2bab2947e1fe96b3910ec62d52",
    "linux-aarch64": "afd5b5bb55afb3785e9b70521f64308a37e4e6db3b55699c8d2c63e620d562f7",
    "macos-x86_64": "ca00b4de38d8d32738e72b0c1efb1624adae22558f8fcdd9bf4ea2f568807705",
    "macos-aarch64": "c3cb75d8a539f598fa5600db43a8bc0fbf53bfa77412754d0d5abfa73622c8a2",
}

ZIG_TOOL_PATH = "tools/{zig_tool}"
ZIG_TOOL_WRAPPER = """#!/bin/bash
set -e

if [[ -n "$TMPDIR" ]]; then
  _cache_prefix=$TMPDIR
else
  _cache_prefix="$HOME/.cache"
  if [[ "$(uname)" = Darwin ]]; then
    _cache_prefix="$HOME/Library/Caches"
  fi
fi
export ZIG_LOCAL_CACHE_DIR="$_cache_prefix/bazel-zig-cc"
export ZIG_GLOBAL_CACHE_DIR=$ZIG_LOCAL_CACHE_DIR

exec "{zig}" "{zig_tool}" "$@"
"""

_ZIG_TOOLS = [
    "c++",
    "cc",
    "ar",
    "ld.lld",
]

_BUILD_FILE_FOR_CARGO_TEMPLATE = """\
load("@rules_lambda//lambdas/toolchains:zig_repositories.bzl", "define_toolchain")
define_toolchain(
    absolute_path = {absolute_path},
)"""

def _zig_repository_impl(repository_ctx):
    arch = repository_ctx.os.arch
    if arch == "amd64":
        arch = "x86_64"

    os = repository_ctx.os.name.lower()
    if os.startswith("mac os"):
        os = "macos"

    host_platform = "{}-{}".format(os, arch)

    zig_sha256 = repository_ctx.attr.sha256[host_platform]
    format_vars = {
        "version": repository_ctx.attr.version,
        "host_platform": host_platform,
    }

    url = [repository_ctx.attr.url_template.format(**format_vars)]
    repository_ctx.download_and_extract(
        auth = use_netrc(read_user_netrc(repository_ctx), url, {}),
        url = url,
        stripPrefix = "zig-{host_platform}-{version}/".format(**format_vars),
        sha256 = zig_sha256,
    )

    for zig_tool in _ZIG_TOOLS:
        repository_ctx.file(
            ZIG_TOOL_PATH.format(zig_tool = zig_tool),
            ZIG_TOOL_WRAPPER.format(
                zig = str(repository_ctx.path("zig")),
                zig_tool = zig_tool,
            ),
        )

    repository_ctx.file(
        "BUILD.bazel",
        _BUILD_FILE_FOR_CARGO_TEMPLATE.format(
            absolute_path = shell.quote(str(repository_ctx.path(""))),
        ),
    )

zig_repository = repository_rule(
    attrs = {
        "version": attr.string(),
        "sha256": attr.string_dict(),
        "url_template": attr.string(),
    },
    implementation = _zig_repository_impl,
)

# buildifier: disable=unnamed-macro
def zig_register_toolchains(
        register = [],
        version = _VERSION,
        url_template = ZIG_NIGHTLY_URL_TEMPLATE,
        sha256 = _SHA256):
    """
        Register the Zig toolchains.

        Downloads Zig binaries and sets up the toolchains.
        @param register registers the given toolchains.
        @param version the version of Zig to use.
        @url_template tells Bazel where to download the Zig binaries.
        @sha256 the sha256 for the Zig binaries.
    """
    zig_repository(
        name = "zig_sdk",
        version = version,
        url_template = url_template,
        sha256 = sha256,
    )

    toolchains = ["@zig_sdk//:%s_toolchain" % t for t in register]
    native.register_toolchains(*toolchains)

# buildifier: disable=unnamed-macro
def define_toolchain(absolute_path):
    native.filegroup(name = "empty")
    native.exports_files(["zig"], visibility = ["//visibility:public"])
    native.filegroup(name = "lib/std", srcs = native.glob(["lib/std/**"]))

    lazy_filegroups = {}

    for zigcpu in ["aarch64"]:
        zigtarget = "{}-linux-gnu".format(zigcpu)

        absolute_tool_paths = {}
        for name, path in DEFAULT_TOOL_PATHS:
            if path[0] == "/":
                absolute_tool_paths[name] = path
                continue
            tool_path = ZIG_TOOL_PATH.format(zig_tool = path)
            absolute_tool_paths[name] = "%s/%s" % (absolute_path, tool_path)

        zig_cc_toolchain_config(
            name = zigtarget + "_toolchain_cc_config",
            target = zigtarget,
            tool_paths = absolute_tool_paths,
            target_cpu = zigcpu,
        )

        native.cc_toolchain(
            name = zigtarget + "_toolchain_cc",
            toolchain_identifier = zigtarget + "-toolchain",
            toolchain_config = ":%s_toolchain_cc_config" % zigtarget,
            all_files = ":zig",
            ar_files = ":zig",
            compiler_files = ":zig",
            linker_files = ":zig",
            dwp_files = ":empty",
            objcopy_files = ":empty",
            strip_files = ":empty",
            supports_param_files = 0,
        )

        native.toolchain(
            name = zigtarget + "_toolchain",
            exec_compatible_with = None,
            target_compatible_with = [
                "@platforms//os:linux",
                "@platforms//cpu:{}".format(zigcpu),
            ],
            toolchain = ":%s_toolchain_cc" % zigtarget,
            toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        )
