# karaf

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with karaf](#setup)
    * [Beginning with karaf](#beginning-with-karaf)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Module to install Apache Karaf and manage instances.

## Setup

### Beginning with karaf

To install Apache Karaf on your server with default parameters, declare the [`karaf`][] class:

``` puppet
class { 'karaf': }
```

## Usage

In case you want to run Karaf with a different account, you can configure it:

``` puppet
class { 'karaf':
    service_user_name  => 'myuser',
    service_user_id    => 1050,
    service_group_name => 'mygroup',
    service_group_id   => 1050,
}
```

If you want to use an already existing account to run Karaf, tell the module not to create the account. You can omit the service_user_id and service_group_id. The service_user_name and service_group_name still need to be provided:

``` puppet
class { 'karaf':
    manage_user        => false,
    service_user_name  => 'myuser',
    service_group_name => 'mygroup',
}
```

To store data and logs in other directory:

``` puppet
class { 'karaf':
    pidfile          => '/store/karaf/karaf.pid',
    default_env_vars => {
                            'KARAF_DATA' => '/store/karaf/data/',
                            'KARAF_LOG'  => '/store/karaf/logs/',
    },
}
```

To use your own repository, with authentication:

``` puppet
class { 'karaf':
    mvn_repositories => ['https://www.example.com/repository/my-repo/@id=central@snapshots'],
    m2_settings      => {
                        'servers' => [{
                            'id'       => 'central',
                            'username' => 'myuser',
                            'password' => 'secret',
                        }],
                        'mirrors' => [{
                            'id'       => 'central',
                            'name'     => 'My Repository',
                            'url'      => 'https://www.example.com/repository/my-repo/',
                            'mirrorOf' => '*',
                        }]
                        },
}
```

## Limitations

In this version, configuring instances is not yet possible.

## Development

I highly welcome new contributions to this module, especially those that include documentation, and rspec tests ;) but will happily guide you through the process, so, yes, please submit that pull request!

