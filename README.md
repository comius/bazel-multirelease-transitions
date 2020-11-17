
# Java Multirelease POC

This is a proof of concept how to create a jar file containing multiple Java
versions. Intent is to demonstrate use of configuration transitions.

## Problems

I don't know much about MR jars. Currently the example just adds all classes to a single
jar without changing the path or adding `moduleinfo.class`.

The code uses locally installed JDK8, because there is no `remote_jdk8`. User should fix the path in `WORKSPACE` file.

## Test

```
$ bazel build //:binary8+11
$ mkdir tmp
$ cd tmp
$ unzip  ../bazel-bin/binary8+11.jar
$ javap -verbose A.class | grep "major"
  major version: 52
$ javap -verbose B.class | grep "major"
  major version: 55
```
