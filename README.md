# Mesos Packaging

This repository contains [Hammer](https://github.com/asteris-llc/hammer) specs
for building [Apache Mesos](http://mesos.apache.org).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Mesos Packaging](#mesos-packaging)
    - [Dynamic Configuration](#dynamic-configuration)
        - [Per-node Configuration](#per-node-configuration)
    - [Packages](#packages)
        - [Core](#core)
            - [mesos](#mesos)
            - [mesos-master](#mesos-master)
            - [mesos-master-dynamic](#mesos-master-dynamic)
            - [mesos-agent](#mesos-agent)
            - [mesos-agent-dynamic](#mesos-agent-dynamic)
        - [Frameworks](#frameworks)
            - [marathon](#marathon)
            - [marathon-dynamic](#marathon-dynamic)
    - [Building](#building)

<!-- markdown-toc end -->

## Dynamic Configuration

Dynamic configuration is performed with [Consul](https://consul.io). The
`{package}-dynamic` entries in this README describe the key spaces they look for
to render configuration to disk. Be aware that most of these daemons need to be
restarted when configuration changes, so account for that when you're changing
keys.

### Per-node Configuration

In addition to the documented keys under each package, you can set per-node
global options for these packages with certain flags. These will be documented
in the config files if not set, but here's a short list:

| Key                               | Description                |
|-----------------------------------|----------------------------|
| `config/nodes/{node}/external_ip` | node's external IP address |
| `config/nodes/{node}/internal_ip` | node's internal IP address |
| `config/nodes/{node}/hostname`    | node's hostname            |

## Packages

### Core

#### mesos

[*spec*](core/mesos/spec.yml)

The base Mesos package, including bindings. There is no configuration in this
package.

#### mesos-master

[*spec*](core/mesos-master/spec.yml)

The mesos master process. This is a configuration-only package, and will provide
the `mesos-master` service by depending on `mesos`. `mesos-master` is configured
via environment variables in `/etc/sysconfig/mesos-master`.

#### mesos-master-dynamic

[*spec*](core/mesos-master-dynamic/spec.yml)

Makes [mesos-master](#mesos-master) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description | Default |
|-----|-------------|---------|
| `config/mesos/agents/{node}/principal` and `config/mesos/agents/{node}/secret` | agent principal(s) and secret(s), respectively | not set |
| `config/mesos/frameworks/{name}/principal` and `config/mesos/frameworks/{name}/secret` | framework principal(s) and secret(s), respectively | not set |
| `config/mesos/master/extra_options` | extra command-line options to pass to `mesos-master` | not set |
| `config/mesos/master/firewall_rules` | see [Mesos docs](http://mesos.apache.org/documentation/latest/configuration/) | `{}` |
| `config/mesos/master/nodes/{node}/options` | same as options, but per-node | not set |
| `config/mesos/master/options` | any key from the [configuration options](http://mesos.apache.org/documentation/latest/configuration/). Value will be uppercased to become an environment variable. | not set |

This package assumes that authentication will be done globally, and so will not
pay attention to unsetting the authentication per-node; it must be done
globally. It also pays attention to both the `authenticate_slaves` and
`authenticate_agents` flags for backwards compatibility.

This package also uses `internal_ip`, `external_ip`, and `hostname` from the
[Per-node Configuration](#per-node-configuration). Do note that you can override
the values set in this way in the configuration by overriding them in
`config/mesos/master/nodes/{node}/options`.

#### mesos-agent

[*spec*](core/mesos-agent/spec.yml)

The mesos agent process (formerly `mesos-slave`). This package name is being
changed in advance of the upstream change to `mesos-agent`, and will call the
appropriate binaries for the version of Mesos provided. This is a
configuration-only package, and will provide the `mesos-agent` service by
depending on `mesos`. `mesos-agent` is configured via environment variables in
`/etc/sysconfig/mesos-agent`.

#### mesos-agent-dynamic

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

### Frameworks

#### marathon

[*spec*](frameworks/marathon/spec.yml)

[Marathon](http://mesosphere.github.io/marathon), a cluster-wide init and
control system for services in cgroups or Docker containers. Marathon can be
controlled with environment variables in `/etc/sysconfig/marathon`, the
available options are documented in the
[Marathon command-line flags documentation](http://mesosphere.github.io/marathon/docs/command-line-flags.html).

#### marathon-dynamic

[*spec*](frameworks/marathon-dynamic/spec.yml)

Makes [marathon](#marathon) dynamic by populating it with
[consul-template](https://github.com/hashicorp/consul-template)
([spec](https://github.com/asteris-llc/consul-packaging/blob/master/packaging/consul-template/spec.yml)).

Available configuration:

| Key | Description |
|-----|-------------|
| `config/marathon/options/{key}` | any key from the [command line flags](http://mesosphere.github.io/marathon/docs/command-line-flags.html). Value will be uppercased to become an environment variable. |
| `config/marathon/hosts/{node}/options/{key}` | the same as `marathon/config/{key}`, but the flags will only be applied to the specified node |

## Building

If you're on linux, run `hammer` to build all of the packages, which will end up
in `out`. If you're on another platform, run `./build.sh` to fire up a Vagrant
VM that will provision itself with hammer and do the same.
