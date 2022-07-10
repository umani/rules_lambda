"""
Defines the C++ settings that tell Bazel precisely how to construct C++
commands, using Zig for a better cross-compilation story.

See https://docs.bazel.build/versions/master/cc-toolchain-config-reference.html
"""

# Heavily based on https://git.sr.ht/~motiejus/bazel-zig-cc

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

compile_and_link_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
]

other_compile_actions = [
    ACTION_NAMES.assemble,
    ACTION_NAMES.cc_flags_make_variable,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.lto_backend,
    ACTION_NAMES.preprocess_assemble,
]

def _compilation_mode_features():
    actions = all_link_actions + compile_and_link_actions + other_compile_actions

    dbg_feature = feature(
        name = "dbg",
        flag_sets = [
            flag_set(
                actions = actions,
                flag_groups = [
                    flag_group(
                        flags = ["-g"],
                    ),
                ],
            ),
        ],
    )

    opt_feature = feature(
        name = "opt",
        flag_sets = [
            flag_set(
                actions = actions,
                flag_groups = [
                    flag_group(
                        flags = ["-O3", "-DNDEBUG"],
                    ),
                ],
            ),
        ],
    )

    fastbuild_feature = feature(
        name = "fastbuild",
        flag_sets = [
            flag_set(
                actions = actions,
                flag_groups = [
                    flag_group(
                        flags = ["-fno-lto", "-Wl,-S", "-O0"],
                    ),
                ],
            ),
        ],
    )

    return [
        dbg_feature,
        opt_feature,
        fastbuild_feature,
    ]

def _zig_cc_toolchain_config_impl(ctx):
    compiler_flags = [
        "-target",
        ctx.attr.target,
        "-no-canonical-prefixes",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ]
    no_gc_sections = ["-Wl,--no-gc-sections"]

    compile_and_link_flags = feature(
        name = "compile_and_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = compile_and_link_actions,
                flag_groups = [
                    flag_group(flags = no_gc_sections),
                    flag_group(flags = compiler_flags),
                ],
            ),
        ],
    )

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        flags = ["-target", ctx.attr.target] + no_gc_sections,
                    ),
                ],
            ),
        ],
    )

    other_compile_flags = feature(
        name = "other_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = other_compile_actions,
                flag_groups = [
                    flag_group(flags = compiler_flags),
                ],
            ),
        ],
    )

    features = [
        compile_and_link_flags,
        other_compile_flags,
        default_linker_flags,
    ] + _compilation_mode_features()

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        toolchain_identifier = "%s-toolchain" % ctx.attr.target,
        target_cpu = ctx.attr.target_cpu,
        tool_paths = [
            tool_path(name = name, path = path)
            for name, path in ctx.attr.tool_paths.items()
        ],
        host_system_name = "local",
        target_system_name = "unknown",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
    )

zig_cc_toolchain_config = rule(
    implementation = _zig_cc_toolchain_config_impl,
    attrs = {
        "target": attr.string(),
        "target_cpu": attr.string(),
        "tool_paths": attr.string_dict(),
    },
    provides = [CcToolchainConfigInfo],
)
