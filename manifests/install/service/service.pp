# @api private
class karaf::install::service::service (
  Enum['present', 'absent'] $ensure,
  Stdlib::Absolutepath $instance_root,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
) {
  if $ensure == 'absent' {
    $service_ensure = 'stopped'
    $service_enable = false

    file { "/etc/init.d/${service_name}":
      ensure => 'absent',
    }
  } else {
    $service_ensure = 'running'
    $service_enable = true

    file { "/etc/init.d/${service_name}":
      ensure  => 'file',
      mode    => '0755',
      content => template('karaf/etc/init.d/karaf.erb'),
      notify  => Service[$service_name],
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
