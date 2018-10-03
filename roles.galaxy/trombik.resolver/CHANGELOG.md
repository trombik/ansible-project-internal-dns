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
