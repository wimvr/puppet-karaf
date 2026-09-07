# @api private
define karaf::instance::rmi (
  String $rmi_registry_host,
  Optional[Integer] $rmi_registry_port = undef,
  String $rmi_server_host,
  Optional[Integer] $rmi_server_port = undef,
  Type[Resource] $x_require,
) {
  ini_setting { "karaf instance ${name} rmiRegistryHost":
    ensure  => 'present',
    path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
    setting => 'rmiRegistryHost',
    value   => $rmi_registry_host,
    require => $x_require,
  }
  if $rmi_registry_port {
    ini_setting { "karaf instance ${name} rmiRegistryPort":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
      setting => 'rmiRegistryPort',
      value   => $rmi_registry_port,
      require => $x_require,
    }
  }
  ini_setting { "karaf instance ${name} rmiServerHost":
    ensure  => 'present',
    path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
    setting => 'rmiServerHost',
    value   => $rmi_server_host,
    require => $x_require,
  }
  if $rmi_server_port {
    ini_setting { "karaf instance ${name} rmiServerPort":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.management.cfg",
      setting => 'rmiServerPort',
      value   => $rmi_server_port,
      require => $x_require,
    }
  }
}
