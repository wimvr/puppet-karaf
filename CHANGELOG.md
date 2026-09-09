# Changelog

All notable changes to this project will be documented in this file.

## Release 1.1.0

**Features**
- configure logging directory for instances
- login on instances via ssh with RSA key from user under which karaf runs
- define the state (started/stopped) of an instance

**Fixed**
- no shared etc & instances dir over different Karaf versions, after upgrade instances need to be build from scratch
- instance defaults via params

## Release 1.0.1

**Features**
- users.properties via template to make sure that not configured accounts are removed
- extend karaf::instance with more configuration options

## Release 1.0.0

**Features**
- Manage instances
- Fact listing all instances with its state
- Remove EL7 support
- Update to current Fedora versions (43, 44)

## Release 0.4.0

**Features**
- Puppet 8 support / Drop Puppet 6
- Added EL9 support
- Use absolute path instead of symlink for systemd files
- Correct replacement of version in download URL
- Add AlmaLinux and Rocky as supported OS

## Release 0.3.0

**Features**
- var for instances_dir

**Fixed**
- puppet/archive: Allow 7.x

## Release 0.2.0

**Features**

**Bugfixes**
- Improved systemd service installation.

**Known Issues**

## Release 0.1.0

**Features**
- Install and configure Apache Karaf.

**Bugfixes**

**Known Issues**
- No support for instances.

