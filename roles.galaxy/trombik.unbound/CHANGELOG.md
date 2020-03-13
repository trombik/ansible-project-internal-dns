## Release 4.0.0

* 8ba6d1b bugfix: introduce `unbound_force_flush_handlers`
* 488af98 bugfix: remove `if else` for old version of unbound
* 6f3e7c6 backward incompatible: change the meaning of unbound_flags
* a6e45a8 bugfix: QA
* 647b99b bugfix: use `result is match` style

## Release 3.1.1

* fa08d26 bugfix: s/x509-certificate/x509_certificate/g
* 3b461b2 bugfix: ignore extra_roles
* a851285 bugfix: s/x509-certificate/x509_certificate/g
* e277017 bugfix: update supported platform versions
* 2d344d0 bugfix: lint
* d151a04 bugfix: QA

## Release 3.0.1

* 217ab1b feature: support FreeBSD 10.4
* 69f654d bugfix: QA
* 0726a47 bugfix: drop FreeBSD 10.3 and Ubuntu 14.04 from the tests (#13)

## Release 3.0.0

* 8ab8f76 [bugfix] make unbound_version `--check` safe, update and fix README (#11)
* cc08ff6 [feature] Support OpenBSD 6.3, drop EoLed releases (#10)
* 551813b [backward incompatible] introduce unbound_config (#9)

### Backward incompatibilities

This release introduces backward incompatibilities.

The major incompatibility is that `unbound.conf(5)` is now empty, allowing
users to build arbitrary one.

Also, `chroot(8)` support has been dropped.

As a result, the following variables have been removed.

* `unbound_config_chroot`
* `unbound_freebsd_chroot_devfs_ruleset_number`
* `unbound_config_server`
* `unbound_config_remote_control_control_enable`
* `unbound_config_remote_control_control_use_cert`
* `unbound_config_remote_control_control_interface`
* `unbound_config_remote_control_extra`
* `unbound_forward_zone`
* `unbound_stub_zone`

## Release 2.3.0

* 3cdfb44 [feature][bugfix] replace `include` with `include_*`, requiring ansible 2.4 #7

## Release 2.2.0

* 8af7d1e [feature] Support FreeBSD 11.1 (#4)

## Release 2.1.2

* a47a187 [bugfix] s/mitsuruy/trombik/g (#2)
* 3b6bf67 [bugfix] Re-import the role and QA (#1)
* 4bc937d [bugfix] fix third party repo, bump rubocop and QA (#49)
* 6c1c70d [bugfix] bump CentOS versions (#46)
* e8fbf56 bump specinfra (#45)
* ddcb3cd [bugfix] QA (#44)
* caecbf5 [bugfix] introduce unbound_include_role_x509_certificate (#43)
* 39a8dbe [feature] implement unbound_flags (#42)

## Release 2.1.1

* b91475b [bugfix] wrong examples in README (#39)

## Release 2.1.0

* 436a3e1 [feature][bugfix] Support unbound 1.6 and OpenBSD 6.1 (#36), closes #34

## Release 2.0.0

* fccbfc6 [bugfix] use reallyenglish.devfsrules, remove chroot hacks (#32)
* c8e56e7 [backward incompatible] support arbitrary settings in unbound.conf(5) (#31)
* 851dbaf QA (#24)
* e57f2f8 Remove a logic to take different actions depending on OS version  (#18)
* faaef16 Connect the integration test to build (#17)
* `unbound_config_directory` was renamed. Use `unbound_directory`
* support stub-zone

Since the last release, `unbound_config_server` supports arbitrary
configurations. You need to modify `unbound_config_server` before upgrading.
See [`unbound_config_server`](https://github.com/reallyenglish/ansible-role-unbound#unbound_config_server)
for details.

## Release 1.0.0

* intial release
