# @api private
define karaf::instance::ssh (
  String $ssh_host,
  Optional[Integer] $ssh_port = undef,
  Type[Resource] $x_require,
) {
  ini_setting { "karaf instance ${name} sshHost":
    ensure  => 'present',
    path    => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.shell.cfg",
    setting => 'sshHost',
    value   => $ssh_host,
    require => $x_require,
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
      require => $x_require,
    }
  }
}
