# Project example

This is an example project to describe how projects are developed.

A project consists of a host or hosts in an environment, providing services to
users, or to other systems as part of a larger system.

Complicated systems should be divided into smaller projects as reasonably as
possible. This is often subjective matter, but a project should not manage
your entire set of all services.

## Requirements

For project development, the followings are required.

* `virtualbox`
* `vagrant`
* `bundler`
* `git`
* `ansible`

Optionally:

* `terraform` when using public or private cloud services

## Installation

Install gems in `Gemfile`.

```
bundle install
```

Install external roles under `roles.galaxy`.

```
ansible-galaxy install -r requirements.yml
```


## Terminologies

### Environments

An environment is where hosts described by playbooks, an `ansible` inventory,
roles, and group variables in a project are created and deployed. A project
often has multiple environments for production and testing. The default
testing environment is `virtualbox` in which each user can test the project on
a local machines. There might be multiple testing environments for different
purposes, such as so-called _private cloud_ where users can test the project
on more powerful machines, a cloud environment where others, possibly other
developers and end-users, can actually see the system being developed, or a
pre-production environment under the same conditions as the production system
where final tests can be performed.

### Static tests

Static tests are tests that do not affect the subjects being tested.
Strictly speaking, all tests affect the subjects; some are negligible, others
are not.  Simply put, static tests are read-only, non-destructive tests.

A test in projects can be regarded as static when:

* The test does not create, modify, or delete files, records, or states of
  subjects
* The test can be performed several times, and it produces the same results

A static test MUST:

* produce the same result no matter what
* NOT change states of files, daemons, databases, networks, or other subjects
* NOT interact with other environments of the project

A static test MAY:

* create temporary files for the test (be sure to remove them)
* create log entries, such as warnings, login entries in `syslog`
* interact with external resources

### Destructive tests


## Layout of directories

### Overview

```
├── inventories # inventory files
│   ├── prod # for production
│   └── virtualbox # for virtualbox environment
├── playbooks # the root of playbook and group_vars files for ansible
│   └── group_vars
├── roles # roles for the project
├── roles.galaxy # where roles listed in requirements.yml are installed
├── ruby # helper ruby libraries go here
└── spec # spec files
    ├── integration # spec files for integration tests
    └── serverspec # spec files for serverspec
        ├── example # specs for hosts in `example`
        ├── shared_examples # for shared specs
        └── virtualbox # specs for hosts in `virtualbox`
```

### `inventories`

The directory keeps inventory files for environments. Each sub-directory has
a corresponding name that represents the environment.

An inventory file is the single source of all inventory information for an
environment. For example, `Rakefile`, which automates some commonly used
tasks, determines which environment, and modifies tasks accordingly.
`Vagrantfile` reads inventory information, and creates VMs. It is also
possible to write `rspec` specs only for a group of hosts described in the
inventory.

`prod` sub-directory has configurations for AWS EC2. Modify them according to
your needs.

### `playbooks`

This is the root directory for `ansible` playbooks. The directory has a sub
directory for variable files, `group_vars`. Generally, `host_vars` is
discouraged, but when you need them, create `host_vars` sub directory under
`playbooks`.

### `roles`

Local roles that have a specific scope to the project reside here. Local roles
must be strictly specific to the project. Creating generic roles that can be
shared in projects are preferred because they are easier to maintain and test.

### `roles.galaxy`

External roles listed in `requirements.yml` are installed under this
directory. Note that, unlike practices used elsewhere, external roles are
supposed to be committed to the repository, which removes on dependencies on
external factors during deployments.

### `ruby`

A directory in which helper ruby libraries are kept. A library that have been
proven to be useful for general use-cases in project development, and to be
mature enough, will be rolled into a gem.

### `spec`

As a testing framework, `rspec` is used, and this directory holds all the
specs and helper files.

#### `serverspec`

#### `integration`

