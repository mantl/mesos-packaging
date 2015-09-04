# Mesos Packaging

This repository contains [Hammer](https://github.com/asteris-llc/hammer) specs
for building [Apache Mesos](http://mesos.apache.org).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Mesos Packaging](#mesos-packaging)
    - [Packages](#packages)
        - [mesos](#mesos)
        - [mesos-master](#mesos-master)
        - [mesos-agent](#mesos-agent)
        - [mesos-agent-dynamic](#mesos-agent-dynamic)
    - [Building](#building)

<!-- markdown-toc end -->

## Packages

### mesos

[*spec*](packaging/mesos/spec.yml)

The base Mesos package, including bindings. There is no configuration in this
package.

### mesos-master

[*spec*](packaging/mesos-master/spec.yml)

The mesos master process. This is a configuration-only package, and will provide
the `mesos-master` service by depending on `mesos`. `mesos-master` is configured
via environment variables in `/etc/sysconfig/mesos-master`.

### mesos-agent

[*spec*](packaging/mesos-agent/spec.yml)

The mesos agent process (formerly `mesos-slave`). This package name is being
changed in advance of the upstream change to `mesos-agent`, and will call the
appropriate binaries for the version of Mesos provided. This is a
configuration-only package, and will provide the `mesos-agent` service by
depending on `mesos`. `mesos-agent` is configured via environment variables in
`/etc/sysconfig/mesos-agent`.

### mesos-agent-dynamic

[*spec*](packaging/mesos-agent-dynamic/spec.yml)

Makes [mesos-agent](#mesos-agent) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description | Default |
|-----|-------------|---------|
| `mesos/agent/containerizers` | containerizer list | `mesos` |
| `mesos/agent/firewall_rules` | see [Mesos docs](http://mesos.apache.org/documentation/latest/configuration/) | `{}` |
| `mesos/agent/logging_level` | log verbosity level | `INFO` |
| `mesos/agent/opts` | extra options in command-line form | not set |
| `mesos/agents/{node}/attributes` | the node attributes | not set |
| `mesos/agents/{node}/ip` | on a per-node level, the IP to listen on | not set |
| `mesos/agents/{node}/port` | on a per-node level, the port to listen on | `5051` |
| `mesos/agents/{node}/principal` and `mesos/agents/{node}/secret` | agent principal and secret, respectively | not set |
| `mesos/zk` | zookeeper address | `zk://localhost:2181/mesos` |

## Building

If you`re on linux, run `hammer` to build all of the packages, which will end up
in `out`. If you're on another platform, run `./build.sh` to fire up a Vagrant
VM that will provision itself with hammer and do the same.
