<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Macro to compile and package AWS Lambdas defined in Rust

<a id="rust_lambda"></a>

## rust_lambda

<pre>
rust_lambda(<a href="#rust_lambda-name">name</a>, <a href="#rust_lambda-srcs">srcs</a>, <a href="#rust_lambda-arch">arch</a>, <a href="#rust_lambda-visibility">visibility</a>, <a href="#rust_lambda-kwargs">kwargs</a>)
</pre>

Compiles and packages an AWS Lambda written in Rust.

The macro expands to these targets:
* `[name]` - the Rust binary for the host platform.
* `[name]_packaged` - the packaged binary for the selected AWS Lambda platform, outputting `[name].zip`.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="rust_lambda-name"></a>name |  A unique name for this rule.   |  none |
| <a id="rust_lambda-srcs"></a>srcs |  The Rust source files.   |  none |
| <a id="rust_lambda-arch"></a>arch |  The target architecture for the Lambda, <code>x86_64</code> or <code>aarch64</code>.   |  <code>"aarch64"</code> |
| <a id="rust_lambda-visibility"></a>visibility |  The visibility of the <code>rust_binary</code> and packaged Lambda targets.   |  <code>["//visibility:private"]</code> |
| <a id="rust_lambda-kwargs"></a>kwargs |  additional named parameters passed to <code>rust_binary</code>.   |  none |


