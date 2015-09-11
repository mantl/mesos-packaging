# Mesos Packaging

This repository contains [Hammer](https://github.com/asteris-llc/hammer) specs
for building [Apache Mesos](http://mesos.apache.org).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Mesos Packaging](#mesos-packaging)
    - [Packages](#packages)
        - [mesos](#mesos)
        - [mesos-master](#mesos-master)
        - [mesos-master-dynamic](#mesos-master-dynamic)
        - [mesos-agent](#mesos-agent)
        - [mesos-agent-dynamic](#mesos-agent-dynamic)
        - [marathon](#marathon)
        - [marathon-dynamic](#marathon-dynamic)
    - [Building](#building)

<!-- markdown-toc end -->

## Packages

### mesos

[*spec*](core/mesos/spec.yml)

The base Mesos package, including bindings. There is no configuration in this
package.

### mesos-master

[*spec*](core/mesos-master/spec.yml)

The mesos master process. This is a configuration-only package, and will provide
the `mesos-master` service by depending on `mesos`. `mesos-master` is configured
via environment variables in `/etc/sysconfig/mesos-master`.

### mesos-master-dynamic

[*spec*](core/mesos-master-dynamic/spec.yml)

Makes [mesos-master](#mesos-master) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description | Default |
|-----|-------------|---------|
| `mesos/agents/{node}/principal` and `mesos/agents/{node}/secret` | agent principal(s) and secret(s), respectively | not set |
| `mesos/frameworks/{name}/principal` and `mesos/frameworks/{name}/secret` | framework principal(s) and secret(s), respectively | not set |
| `mesos/master/authenticate_agents` | authenticate agents | not set (set to any value to activate) |
| `mesos/master/authenticate` | authenticate frameworks | not set (set to any value to activate) |
| `mesos/master/cluster` | cluster name | `mesos` |
| `mesos/master/firewall_rules` | see [Mesos docs](http://mesos.apache.org/documentation/latest/configuration/) | `{}` |
| `mesos/master/logging_level` | log verbosity level | `INFO` |
| `mesos/master/offer_timeout` | timeout for offers to frameworks | not set |
| `mesos/master/opts` | extra options to pass to `mesos-master` | not set |
| `mesos/master/quorum` | quorum to elect a leader | `1` |
| `mesos/master/roles` | allocation roles that frameworks may belong to | not set |
| `mesos/master/weights` | weights for roles int he cluster | not set |
| `mesos/masters/{node}/advertise_ip` | on a per-node level, the advertised IP | not set |
| `mesos/masters/{node}/advertise_port` | on a per-node level, the advertised port | `5050` |
| `mesos/masters/{node}/hostname` | on a per-node level, the hostname to advertise | `5050` |
| `mesos/masters/{node}/ip` | on a per-node level, the IP to listen on | not set |
| `mesos/masters/{node}/port` | on a per-node level, the port to listen on | `5050` |
| `mesos/zk` | zookeeper address | `zk://localhost:2181/mesos` |

### mesos-agent

[*spec*](core/mesos-agent/spec.yml)

The mesos agent process (formerly `mesos-slave`). This package name is being
changed in advance of the upstream change to `mesos-agent`, and will call the
appropriate binaries for the version of Mesos provided. This is a
configuration-only package, and will provide the `mesos-agent` service by
depending on `mesos`. `mesos-agent` is configured via environment variables in
`/etc/sysconfig/mesos-agent`.

### mesos-agent-dynamic

[*spec*](core/mesos-agent-dynamic/spec.yml)

Makes [mesos-agent](#mesos-agent) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description | Default |
|-----|-------------|---------|
| `mesos/agent/containerizers` | containerizer list | `mesos` |
| `mesos/agent/firewall_rules` | see [Mesos docs](http://mesos.apache.org/documentation/latest/configuration/) | `{}` |
| `mesos/agent/logging_level` | log verbosity level | `INFO` |
| `mesos/agent/opts` | extra options to pass to `mesos-agent` | not set |
| `mesos/agents/{node}/attributes` | the node attributes | not set |
| `mesos/agents/{node}/ip` | on a per-node level, the IP to listen on | not set |
| `mesos/agents/{node}/port` | on a per-node level, the port to listen on | `5051` |
| `mesos/agents/{node}/principal` and `mesos/agents/{node}/secret` | agent principal and secret, respectively | not set |
| `mesos/zk` | zookeeper address | `zk://localhost:2181/mesos` |

### marathon

[*spec*](frameworks/marathon/spec.yml)

[Marathon](http://mesosphere.github.io/marathon), a cluster-wide init and
control system for services in cgroups or Docker containers. Marathon can be
controlled with environment variables in `/etc/sysconfig/marathon`, the
available options are documented in the
[Marathon command-line flags documentation](http://mesosphere.github.io/marathon/docs/command-line-flags.html).

### marathon-dynamic

[*spec*](frameworks/marathon-dynamic/spec.yml)

Makes [marathon](#marathon) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description |
|-----|-------------|
| `marathon/config/{key}` | any key from the [command line flags](http://mesosphere.github.io/marathon/docs/command-line-flags.html). Value will be uppercased to become an environment variable. |
| `marathon/nodes/{node}/config/{key}` | the same as `marathon/config/{key}`, but the flags will only be applied to the specified node |

## Building

If you`re on linux, run `hammer` to build all of the packages, which will end up
in `out`. If you're on another platform, run `./build.sh` to fire up a Vagrant
VM that will provision itself with hammer and do the same.
