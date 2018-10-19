# Internal DNS project

This project manages DNS system for my internal networks.

The project is managed by a `Rakefile`, which provides most of common
operations, such as deploying and testing. Available targets can be shown by:

```
bundle exec rake -T
```

## Environments

The project has two environments. To choose environment, set
`ANSIBLE_ENVIRONMENT` variable. If the environment variable is not defined, it
defaults to `virtualbox`.

### `virtualbox`

The `virtualbox` environment is a test environment on `virtualbox`. The
environment is isolated from external network, completely running on your
local machine.

### `prod`

The `prod` environment is the live, production environment.

## Usage

To deploy in an environment run `up` and `provision` targets.

```
bundle exec rake up provision
```

To perform unit tests, run `test:serverspec:all` target.

```
bundle exec rake test:serverspec:all
```

To perform integration tests, run `test:integration:all` target.

```
bundle exec rake test:integration:all
```
