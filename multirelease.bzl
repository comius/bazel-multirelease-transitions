def _java8_transition_implementation(setting, attr):
    return {
        "//command_line_option:javabase": "@local_jdk8//:jdk",  # There is no @remote_jdk8 repository.
        "//command_line_option:java_toolchain": "@bazel_tools//tools/jdk:toolchain_java8",
    }

java8_transition = transition(
    implementation = _java8_transition_implementation,
    inputs = [],
    outputs = ["//command_line_option:javabase", "//command_line_option:java_toolchain"],
)

def _java11_transition_implementation(setting, attr):
    return {
        "//command_line_option:javabase": "@remotejdk11_linux//:jdk",
        "//command_line_option:java_toolchain": "@bazel_tools//tools/jdk:toolchain_java11",
    }

java11_transition = transition(
    implementation = _java11_transition_implementation,
    inputs = [],
    outputs = ["//command_line_option:javabase", "//command_line_option:java_toolchain"],
)

def _java_multirelease_binary_impl(ctx):
    inputs = ctx.files.deps8 + ctx.files.deps11
    jar = ctx.actions.declare_file(ctx.attr.name + ".jar")
    args = ctx.actions.args()
    args.add_all("--sources", inputs)
    args.add("--output", jar)
    ctx.actions.run(
        inputs = inputs,
        outputs = [jar],
        executable = ctx.attr._java_toolchain[java_common.JavaToolchainInfo].single_jar,
        arguments = [args],
    )

    return [DefaultInfo(files = depset([jar]))]
  
java_multirelease_binary = rule(
    implementation = _java_multirelease_binary_impl,
    attrs = {
        "deps8": attr.label_list(cfg = java8_transition),
        "deps11": attr.label_list(cfg = java11_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "_java_toolchain": attr.label(
            default = "@bazel_tools//tools/jdk:current_java_toolchain",
            providers = [java_common.JavaRuntimeInfo],
        ),
    },
)
