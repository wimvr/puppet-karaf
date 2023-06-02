# @api private
class karaf::install::service::systemd (
  Enum['present', 'absent'] $ensure,
  Stdlib::Absolutepath $instance_root,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
) {
  if $ensure == 'absent' {
    $service_ensure = 'stopped'
    $service_enable = false

    file { "/lib/systemd/system/${service_name}.service":
      ensure => 'absent',
    }
  } else {
    $service_ensure = 'running'
    $service_enable = true

    file { "/lib/systemd/system/${service_name}.service":
      ensure  => 'file',
      content => template('karaf/etc/systemd/karaf.erb'),
      notify  => Exec['karaf - systemd daemon-reload'],
    }

    exec { 'karaf - systemd daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
    }
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => "${service_name}.service",
    hasstatus  => true,
    hasrestart => true,
    provider   => 'systemd',
  }
}
