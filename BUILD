load("//:multirelease.bzl", "java_multirelease_binary")

java_library(
    name = "library8",
    srcs = ["A.java"],
)

java_library(
    name = "library11",
    srcs = ["B.java"],
)

java_multirelease_binary(
    name = "binary8+11",
    deps11 = [":library11"],
    deps8 = [":library8"],
)
