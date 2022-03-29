# Example:
# {
#     "x86_64-unknown-linux-gnu": "https://domain.com/downloads/cargo-bazel-x86_64-unknown-linux-gnu",
#     "x86_64-apple-darwin": "https://domain.com/downloads/cargo-bazel-x86_64-apple-darwin",
#     "x86_64-pc-windows-msvc": "https://domain.com/downloads/cargo-bazel-x86_64-pc-windows-msvc",
# }
CARGO_BAZEL_URLS = {
    "x86_64-apple-darwin": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-x86_64-apple-darwin",
    "x86_64-pc-windows-gnu": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-x86_64-pc-windows-gnu.exe",
    "aarch64-unknown-linux-gnu": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-musl": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-x86_64-unknown-linux-musl",
    "x86_64-unknown-linux-gnu": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-x86_64-unknown-linux-gnu",
    "x86_64-pc-windows-msvc": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-x86_64-pc-windows-msvc.exe",
    "aarch64-apple-darwin": "https://github.com/bazelbuild/rules_rust/releases/download/0.1.0/cargo-bazel-aarch64-apple-darwin",
}

# Example:
# {
#     "x86_64-unknown-linux-gnu": "1d687fcc860dc8a1aa6198e531f0aee0637ed506d6a412fe2b9884ff5b2b17c0",
#     "x86_64-apple-darwin": "0363e450125002f581d29cf632cc876225d738cfa433afa85ca557afb671eafa",
#     "x86_64-pc-windows-msvc": "f5647261d989f63dafb2c3cb8e131b225338a790386c06cf7112e43dd9805882",
# }
CARGO_BAZEL_SHA256S = {
    "aarch64-unknown-linux-gnu": "afb0328a3d3640a05ea8d07a688ed3332da35c3744642c34815cc138dafd155d",
    "x86_64-unknown-linux-gnu": "35da01ea1549551b73c118077bc4e3af8da62a6eb5e8a52312baa036e96af97b",
    "x86_64-pc-windows-msvc": "563ced1e6adda0f398b110cc0541be1b3bc196f18ad903ef6fccbd74c387f42e",
    "aarch64-apple-darwin": "dd9e5e2d32cc1b2789c9792be6cdfab666e662697edc7d562880cac186016854",
    "x86_64-apple-darwin": "9497a84831803b6d8d5d7f7677e5f16b71bc3f2b60c902d06ac56850f707bedf",
    "x86_64-pc-windows-gnu": "a6e31954fa7822357e61f56e89068cea68616c2680ac573a242ae96f47a7513b",
    "x86_64-unknown-linux-musl": "d030287fd1ff31bbe1f24d4b70dcf7993259eb8257b94c282dfc05e176f639e8",
}
