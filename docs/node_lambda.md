<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Macro to package AWS Lambdas defined in Javascript

<a id="node_lambda"></a>

## node_lambda

<pre>
node_lambda(<a href="#node_lambda-name">name</a>, <a href="#node_lambda-bundler">bundler</a>, <a href="#node_lambda-srcs">srcs</a>, <a href="#node_lambda-deps">deps</a>, <a href="#node_lambda-entry_point">entry_point</a>, <a href="#node_lambda-entry_points">entry_points</a>, <a href="#node_lambda-visibility">visibility</a>)
</pre>

Packages one or more AWS Lambdas targetting Node.js.

The macro expands to these targets:
* `[name]` - the Javascript bundle.
* `[name]_packaged` - the packaged bundle, outputting `[name].zip`.
  If `entry_points` is specified, we use `entry_points[i]` instead of `name`.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="node_lambda-name"></a>name |  A unique name for this rule.   |  none |
| <a id="node_lambda-bundler"></a>bundler |  A tool that produces the bundle. This attribute accepts a rule or macro with the signature: <code>name, srcs, deps, entry_point, entry_points, external, define, minify, **kwargs</code>, where:  <code>external</code> is a list of module names that are not included in the resulting bundle;  <code>define</code> is a dict of global identifier replacements;  <code>minify</code> indicates whether the bundle should be minified;  <code>**kwargs</code> propagates the <code>visibility</code> attribute. The remaining attributes are forwarded the corresponding values passed to this rule.   |  none |
| <a id="node_lambda-srcs"></a>srcs |  The Lambda source files.   |  <code>[]</code> |
| <a id="node_lambda-deps"></a>deps |  Direct dependencies required to build the bundle.   |  <code>[]</code> |
| <a id="node_lambda-entry_point"></a>entry_point |  The bundle's entry point (e.g. your main.js or app.js or index.js). This is a shortcut for the <code>entry_points</code> attribute with a single entry. Specify either this attribute or <code>entry_point</code>, but not both.   |  <code>None</code> |
| <a id="node_lambda-entry_points"></a>entry_points |  The bundle's entry points (e.g. your main.js or app.js or index.js). Specify either this attribute or <code>entry_point</code>, but not both.   |  <code>[]</code> |
| <a id="node_lambda-visibility"></a>visibility |  The visibility of the bundle and the packaged Lambda targets.   |  <code>["//visibility:private"]</code> |


