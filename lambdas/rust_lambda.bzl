""" Macro to compile and package AWS Lambdas defined in Rust """

load("@rules_rust//rust:defs.bzl", "rust_binary", "rust_test")
load("@rules_rust//rust:rust_common.bzl", "CrateInfo")

def _impl(settings, attr):
    _ignore = (settings, attr)
    return {"//command_line_option:platforms": "//lambdas/platform:lambda"}

_lambda_platform_transition = transition(
    implementation = _impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)

# The implementation of transition_rule: all this does is move the
# rust_binary's output to its own output and propagate its runfiles.
def _transition_rule_impl(ctx):
    rust_binary = ctx.attr.rust_binary[0]
    outfile = ctx.actions.declare_file(ctx.label.name)
    rust_binary_outfile = rust_binary[DefaultInfo].files.to_list()[0]
    ctx.actions.run_shell(
        inputs = [rust_binary_outfile],
        outputs = [outfile],
        command = "mv %s %s" % (rust_binary_outfile.path, outfile.path),
    )
    return [
        DefaultInfo(
            files = depset([outfile]),
            data_runfiles = rust_binary[DefaultInfo].data_runfiles,
        ),
        rust_binary[CrateInfo],
    ]

_transition_rule = rule(
    implementation = _transition_rule_impl,
    attrs = {
        # Outgoing edge transition
        "rust_binary": attr.label(cfg = _lambda_platform_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def rust_lambda(name, visibility, **kwargs):
    """Compiles and packages an AWS Lambda written in Rust

    The macro expands to these targets:
    * [name]_bin - the Rust binary for the host platform
    * [name]_aws_bin - the Rust binary for the AWS Lambda platform
    * [name]_test - test target for the unit tests in the crate
    * [name] - the packaged binary, outputting [name].zip

    Args:
        name: A name for the target
        visibility: The visibility of the target for the packaged lambda
        **kwargs: additional named parameters passed to rust_binary
    """
    binary_name = name + "_bin"
    target_name = name + "_aws_bin"
    test_name = name + "_test"
    _transition_rule(
        name = target_name,
        rust_binary = binary_name,
    )
    rust_binary(
        name = binary_name,
        **kwargs
    )
    native.genrule(
        name = name,
        srcs = [target_name],
        outs = [name + ".zip"],
        cmd = "cp $(execpath %s) bootstrap && zip -q -j $@ bootstrap" % target_name,
        visibility = visibility,
    )
    rust_test(
        name = name + "_test",
        crate = binary_name,
        size = "small",
    )
