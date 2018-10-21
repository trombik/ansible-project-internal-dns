## Release 2.2.0

* 9ecd965 docmentation: remove predictable_shuffle
* 17ea507 bugfix: update README
* f495943 bugfix: replace predictable_shuffle with official filter shuffle
* c0510bc bugfix: drop stale boxes, update meta
* 52cf015 bugfix: QA
* 3ad1d90 feature: support arbitrary config in resolv.conf(5)

## Release 2.1.0

* 3d6e8a7 [feature] Support OpenBSD 6.3, FreeBSD 10.4, and Ubuntu 18.04 (#5)

## Release 2.0.2

* ba4809f [bugfix] remove pre_tasks in a test (#3)

## Release 2.0.1

* 07ffde0 [bugfix] use ansible_hostname instead of ansible_fqdn (#1)
* 1ab234f [bugfix] QA (#13)
* 02263f8 QA (#12)
* 4b26f8f QA (#11)

## Release 2.0.0

* `resolver_dhclient_enabled` has been removed. If DHCP client is running on
  the host, the role should not be used. Use
  [ansible-role-dhclient](https://github.com/reallyenglish/ansible-role-dhclient/)
  instaed.
* `predictable_shuffle` is now optional. You should `predictable_shuffle` yourself.
* Support Ubuntu
* Support CentOS

## Release 1.0.0

* initial release
