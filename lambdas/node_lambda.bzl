"""Macro to package AWS Lambdas defined in Javascript"""

load("@aspect_bazel_lib//lib:directory_path.bzl", "make_directory_path")
load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")

# Note: the `bundler` attribute is basically a workaround for the absence of
# an esbuild rule. Currently, that rule is distributed through npm, but here
# we don't want to take on that dependency.
def node_lambda(name, bundler, srcs = [], deps = [], entry_point = None, entry_points = [], visibility = ["//visibility:private"]):
    """Packages one or more AWS Lambdas targetting Node.js.

    The macro expands to these targets:
    * `[name]` - the Javascript bundle.
    * `[name]_packaged` - the packaged bundle, outputting `[name].zip`.
      If `entry_points` is specified, we use `entry_points[i]` instead of `name`.

    Args:
        name: A unique name for this rule.
        bundler: A tool that produces the bundle. This attribute accepts a rule or macro with the
                signature: `name, srcs, deps, entry_point, entry_points, external, define, minify, **kwargs`, where:
                 `external` is a list of module names that are not included in the resulting bundle;
                 `define` is a dict of global identifier replacements;
                 `minify` indicates whether the bundle should be minified;
                 `**kwargs` propagates the `visibility` attribute.
                The remaining attributes are forwarded the corresponding values passed to this rule.
        srcs: The Lambda source files.
        entry_point: The bundle's entry point (e.g. your main.js or app.js or index.js). This is a shortcut for the
                     `entry_points` attribute with a single entry.
                     Specify either this attribute or `entry_point`, but not both.
        entry_points: The bundle's entry points (e.g. your main.js or app.js or index.js).
                      Specify either this attribute or `entry_point`, but not both.
        deps: Direct dependencies required to build the bundle.
        visibility: The visibility of the bundle and the packaged Lambda targets.
    """
    mode = name + "_mode"
    native.config_setting(
        name = mode,
        values = {
            "compilation_mode": "dbg",
        },
    )
    bundler(
        name = name,
        srcs = srcs,
        deps = deps,
        entry_point = entry_point,
        entry_points = entry_points,
        # The v2 of the AWS SDK is available
        # https://docs.aws.amazon.com/lambda/latest/dg/lambda-nodejs.html
        external = [
            "aws-sdk",
            "aws-sdk/*",
        ],
        define = select({
            mode: {
                "process.env.NODE_ENV": "development",
            },
            "//conditions:default": {
                "process.env.NODE_ENV": "production",
            },
        }),
        minify = select({
            mode: False,
            "//conditions:default": True,
        }),
        visibility = visibility,
    )
    if entry_points and len(entry_points) > 1:
        for ep in entry_points:
            # Split the extension since they entry points may end in ".ts"
            (epname, _) = paths.split_extension(ep)
            epname = paths.basename(epname)
            file = epname + ".js"

            # The bundler outputs an opaque directory to Bazel
            src = make_directory_path(
                name = epname + "_path",
                directory = name,
                path = file,
            )

            # pkg_zip doesn't understand the `DirectoryPathInfo` produced
            # by make_directory_path, so copy the file
            copy_file(epname + "_copy", src, file)

            pkg_zip(
                name = epname + "_packaged",
                srcs = [file],
                package_file_name = epname + ".zip",
                visibility = visibility,
            )
    else:
        pkg_zip(
            name = name + "_packaged",
            srcs = [name],
            package_file_name = name + ".zip",
            visibility = visibility,
        )
