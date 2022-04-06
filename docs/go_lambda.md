<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Macro to compile and package AWS Lambdas defined in Go

<a id="#go_lambda"></a>

## go_lambda

<pre>
go_lambda(<a href="#go_lambda-name">name</a>, <a href="#go_lambda-srcs">srcs</a>, <a href="#go_lambda-arch">arch</a>, <a href="#go_lambda-visibility">visibility</a>, <a href="#go_lambda-kwargs">kwargs</a>)
</pre>

Compiles and packages an AWS Lambda written in Go.

The macro expands to these targets:
* `[name]` - the Go library for the host platform.
* `[name]_binary` - the Go binary for the host platform.
* `[name]_packaged` - the packaged binary for the selected AWS Lambda platform, outputting `[name].zip`.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="go_lambda-name"></a>name |  A unique name for this rule.   |  none |
| <a id="go_lambda-srcs"></a>srcs |  The Go source files.   |  none |
| <a id="go_lambda-arch"></a>arch |  The target architecture for the Lambda, <code>x86_64</code> or <code>aarch64</code>.   |  <code>"x86_64"</code> |
| <a id="go_lambda-visibility"></a>visibility |  The visibility of <code>go_binary</code> and packaged Lambda targets.   |  <code>["//visibility:private"]</code> |
| <a id="go_lambda-kwargs"></a>kwargs |  additional named parameters passed to <code>go_library</code>.   |  none |


