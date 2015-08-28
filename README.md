# Mesos Packaging

This repository contains [Hammer](https://github.com/asteris-llc/hammer) specs
for building [Apache Mesos](http://mesos.apache.org).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Mesos Packaging](#mesos-packaging)
    - [Packages](#packages)
        - [`mesos`](#mesos)
        - [`mesos-agent`](#mesos-agent)
    - [Building](#building)

<!-- markdown-toc end -->

## Packages

### `mesos`

[spec](packaging/mesos/spec.yml)

The base Mesos package, including bindings. There is no configuration in this
package.

### `mesos-agent`

[spec](packaging/mesos-agent/spec.yml)

The mesos agent process (formerly `mesos-slave`). This package name is being
changed in advance of the upstream change to `mesos-agent`, and will call the
appropriate binaries for the version of Mesos provided. This is a
configuration-only package, and will provide the `mesos-agent` service by
depending on `mesos`

`mesos-agent` is configured via environment variables in
`/etc/sysconfig/mesos-agent`.

## Building

If you're on linux, run `hammer` to build all of the packages, which will end up
in `out`. If you're on another platform, run `./build.sh` to fire up a Vagrant
VM that will provision itself with hammer and do the same.
