# ansible-role-unbound

Configures `unbound`.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `unbound_user` | user of `unbound` | `{{ __unbound_user }}` |
| `unbound_group` | group of `unbound` | `{{ __unbound_group }}` |
| `unbound_service` | service name of `unbound` | `unbound` |
| `unbound_package` | package name of `unbound` | `unbound` |
| `unbound_conf_dir` | path to config directory | `{{ __unbound_conf_dir }}` |
| `unbound_conf_file` | path to `unbound.conf(5)` | `{{ unbound_conf_dir }}/unbound.conf` |
| `unbound_flags` | dict of variables and their values in startup scripts. this variable is combined with `unbound_flags_default` (see below). | `{}` |
| `unbound_flags_default` | dict of default variables and their values in startup scripts | `{{ __unbound_flags_default }}` |
| `unbound_script_dir` | directory to install scripts in `files` | `{{ __unbound_script_dir }}` |
| `unbound_directory` | work directory of `unbound` | `{{ __unbound_directory }}` |
| `unbound_include_role_x509_certificate` | include and execute `trombik.x509_certificate` when true | `no` |
| `unbound_config_server_key_file` | `server-key-file` | `{{ unbound_conf_dir }}/unbound_server.key` |
| `unbound_config_server_cert_file` | `server-cert-file` | `{{ unbound_conf_dir }}/unbound_server.pem` |
| `unbound_config_control_key_file` | `control-key-file` | `{{ unbound_conf_dir }}/unbound_control.key` |
| `unbound_config_control_cert_file` | `control-cert-file` | `{{ unbound_conf_dir }}/unbound_control.pem` |
| `unbound_config` | content of `unbound.conf(5)` | `""` |

## `unbound_flags`

This variable is a dict of variables of startup configuration files, such as
files under `/etc/default`, `/etc/sysconfig`, and `/etc/rc.conf.d`. It is
assumed that the files are `source`d by startup mechanism with `sh(1)`. A key
in the dict is name of the variable in the file, and the value of the key is
value of the variable. The variable is combined with a variable whose name is
same as this variable, but postfixed with `_default` (explained below) and the
result creates the startup configuration file, usually a file consisting of
lines of `key="value"` under appropriate directory for the platform.

When the platform is OpenBSD, the above explanation does not apply. In this
case, the only valid key is `flags` and the value of it is passed to
`daemon_flags` described in [`rc.conf(5)`](http://man.openbsd.org/rc.conf),
where `daemon` is the name of one of the `rc.d(8)` daemon control scripts.

## `unbound_flags_default`

This variable is a dict of keys and values derived from upstream's default
configuration, and is supposed to be a constant unless absolutely necessary. By
default, the role creates a startup configuration file for each platform with
this variable, identical to default one.

When the platform is OpenBSD, the variable has a single key, `flags` and its
value is empty string.

## Debian

| Variable | Default |
|----------|---------|
| `__unbound_user` | `unbound` |
| `__unbound_group` | `unbound` |
| `__unbound_conf_dir` | `/etc/unbound` |
| `__unbound_script_dir` | `/usr/bin` |
| `__unbound_directory` | `/etc/unbound` |
| `__unbound_flags_default` | `{}` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__unbound_user` | `unbound` |
| `__unbound_group` | `unbound` |
| `__unbound_conf_dir` | `/usr/local/etc/unbound` |
| `__unbound_script_dir` | `/usr/local/bin` |
| `__unbound_directory` | `/usr/local/etc/unbound` |
| `__unbound_flags_default` | `{}` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__unbound_user` | `_unbound` |
| `__unbound_group` | `_unbound` |
| `__unbound_conf_dir` | `/var/unbound/etc` |
| `__unbound_script_dir` | `/usr/local/bin` |
| `__unbound_directory` | `/var/unbound` |
| `__unbound_flags_default` | `{"flags"=>""}` |

## RedHat

| Variable | Default |
|----------|---------|
| `__unbound_user` | `unbound` |
| `__unbound_group` | `unbound` |
| `__unbound_conf_dir` | `/etc/unbound` |
| `__unbound_script_dir` | `/usr/bin` |
| `__unbound_directory` | `/etc/unbound` |
| `__unbound_flags_default` | `{"UNBOUND_OPTIONS"=>""}` |

# Dependencies

* [`trombik.x509_certificate`](https://github.com/trombik/ansible-role-x509_certificate)
  if `unbound_include_role_x509_certificate` is set to true value.

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-unbound
  vars:
    debian_flags:
      DAEMON_OPTS: "-v -c {{ unbound_conf_file }}"
    freebsd_flags:
      unbound_flags: "-v -c {{ unbound_conf_file }}"
    redhat_flags:
      UNBOUND_OPTIONS: "-v -c {{ unbound_conf_file }}"
    openbsd_flags:
      flags: "-v -c {{ unbound_conf_file }}"

    unbound_flags: "{% if ansible_os_family == 'Debian' %}{{ debian_flags }}{% elif ansible_os_family == 'FreeBSD' %}{{ freebsd_flags }}{% elif ansible_os_family == 'RedHat' %}{{ redhat_flags }}{% elif ansible_os_family == 'OpenBSD' %}{{ openbsd_flags }}{% endif %}"

    unbound_config_chroot: ""
    unbound_config: |
      server:
        chroot: ""
        directory: "{{ unbound_directory }}"
        outgoing-interface: {{ ansible_default_ipv4.address }}
        do-not-query-localhost: yes
        do-ip4: yes
        do-ip6: no
        hide-identity: yes
        hide-version: yes
        use-syslog: yes
        local-zone: 10.in-addr.arpa nodefault
        local-zone: 168.192.in-addr.arpa nodefault
        access-control: 0.0.0.0/0 refuse
        access-control: 127.0.0.0/8 allow
        access-control: 10.100.1.0/24 allow
        private-address: 10.0.0.0/8
        private-address: 172.16.0.0/12
        private-address: 192.168.0.0/16
        private-address: 192.254.0.0/16
        private-address: fc00::/7
        private-address: fd00::/8
        private-address: fe80::/10
        private-domain: "example.com"
        interface: {{ ansible_default_ipv4.address }}
      forward-zone:
        name: "example.com"
        forward-addr: "8.8.8.8"
        forward-addr: "8.8.4.4"
      forward-zone:
        name: "example.org"
        forward-addr: "8.8.8.8"
      stub-zone:
        name: "example.net"
        stub-addr: "8.8.8.8"
        stub-addr: "8.8.4.4"
      stub-zone:
        name: "foo.example"
        stub-addr: "8.8.8.8"
      remote-control:
        control-enable: yes
      {% if unbound_version | version_compare('1.5.2', '>=') %}
        control-use-cert: no
      {% endif %}
      {% if unbound_version | version_compare('1.5.3', '<=') %}
        control-interface: 127.0.0.1
      {% else %}
        control-interface: /var/run/unbound.sock
      {% endif %}
        server-key-file: {{ unbound_conf_dir }}/unbound_server.key
        server-cert-file: {{ unbound_conf_dir }}/unbound_server.pem
        control-key-file: {{ unbound_conf_dir }}/unbound_control.key
        control-cert-file: {{ unbound_conf_dir }}/unbound_control.pem
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [ansible-role-init](https://gist.github.com/trombik/d01e280f02c78618429e334d8e4995c0)
