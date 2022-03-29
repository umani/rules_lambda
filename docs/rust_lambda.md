<!-- Generated with Stardoc: http://skydoc.bazel.build -->

 Macro to compile and package AWS Lambdas defined in Rust 

<a id="#rust_lambda"></a>

## rust_lambda

<pre>
rust_lambda(<a href="#rust_lambda-name">name</a>, <a href="#rust_lambda-visibility">visibility</a>, <a href="#rust_lambda-kwargs">kwargs</a>)
</pre>

Compiles and packages an AWS Lambda written in Rust

The macro expands to these targets:
* [name]_bin - the Rust binary for the host platform
* [name]_aws_bin - the Rust binary for the AWS Lambda platform
* [name]_test - test target for the unit tests in the crate
* [name] - the packaged binary, outputting [name].zip


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="rust_lambda-name"></a>name |  A name for the target   |  none |
| <a id="rust_lambda-visibility"></a>visibility |  The visibility of the target for the packaged lambda   |  none |
| <a id="rust_lambda-kwargs"></a>kwargs |  additional named parameters passed to rust_binary   |  none |


