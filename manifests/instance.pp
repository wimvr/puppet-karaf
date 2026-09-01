# @summary Install and configure an Apache Karaf instance
#
# @param ensure
#   Specifies whether the Apache Karaf instance should be present or absent.
#
# @param ssh_host
#   Host definition of where SSH should listen.
# @param ssh_port
#   Port definition of where SSH should listen.
#
# @param rmi_registry_host
#   Host definition of where RMI registry should listen.
# @param rmi_registry_port
#   Port definition of where RMI registry should listen.
#
# @param rmi_server_host
#   Host definition of where RMI server should listen.
# @param rmi_server_port
#   Port definition of where RMI server should listen.
#
# @param config
#   Additional configuration settings for the instance. Added to config.properties.
define karaf::instance (
  Enum['present', 'absent'] $ensure    = 'present',
  Optional[String] $ssh_host           = '127.0.0.1',
  Optional[Integer] $ssh_port          = undef,
  Optional[String] $rmi_registry_host  = '127.0.0.1',
  Optional[Integer] $rmi_registry_port = undef,
  Optional[String] $rmi_server_host    = '127.0.0.1',
  Optional[Integer] $rmi_server_port   = undef,
  Optional[Hash[String, String]] $config = {},
) {
  if $ensure == 'present' {
    karaf::client { "instance:create ${name}":
      parameters => ['instance:create', $name],
      creates    => "${karaf::install::instances_dir}${name}/",
    }
    $_require = Karaf::Client["instance:create ${name}"]
    ini_setting { "karaf instance ${name} sshHost":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.shell.cfg",
      setting => 'sshHost',
      value   => $ssh_host,
      require => $_require,
    }
    if $ssh_port {
      $_ssh_port = $ssh_port
    } elsif $karaf::remember_ssh_ports {
      $_ssh_port = Deferred('karaf::sshport', [$name, $karaf::install::etc_dir])
    } else {
      $_ssh_port = undef
    }
    if $_ssh_port {
      ini_setting { "karaf instance ${name} sshPort":
        ensure  => 'present',
        path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.shell.cfg",
        setting => 'sshPort',
        value   => $_ssh_port,
        require => $_require,
      }
    }
    ini_setting { "karaf instance ${name} rmiRegistryHost":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
      setting => 'rmiRegistryHost',
      value   => $rmi_registry_host,
      require => $_require,
    }
    if $rmi_registry_port {
      ini_setting { "karaf instance ${name} rmiRegistryPort":
        ensure  => 'present',
        path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
        setting => 'rmiRegistryPort',
        value   => $rmi_registry_port,
        require => $_require,
      }
    }
    ini_setting { "karaf instance ${name} rmiServerHost":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
      setting => 'rmiServerHost',
      value   => $rmi_server_host,
      require => $_require,
    }
    if $rmi_server_port {
      ini_setting { "karaf instance ${name} rmiServerPort":
        ensure  => 'present',
        path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
        setting => 'rmiServerPort',
        value   => $rmi_server_port,
        require => $_require,
      }
    }
    if $config {
      $config.each |String $config_key, String $config_value| {
        ini_setting { "karaf instance ${name} config ${config_key}":
          ensure  => 'present',
          path    => "${karaf::install::instances_dir}${name}/etc/config.properties",
          setting => $config_key,
          value   => $config_value,
          require => $_require,
        }
      }
    }
  } elsif $ensure == 'absent' {
    karaf::client { "instance:destroy ${name}":
      parameters => ['instance:destroy', $name],
      onlyif     => "/usr/bin/test -d ${karaf::install::instances_dir}${name}/",
    }
  }
}
