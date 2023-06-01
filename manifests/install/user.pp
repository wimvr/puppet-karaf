# @api private
class karaf::install::user (
  Enum['present', 'absent'] $ensure = 'present',
  String $service_user_name         = $karaf::params::service_user_name,
  Integer $service_user_id          = $karaf::params::service_user_id,
  String $service_group_name        = $karaf::params::service_group_name,
  Integer $service_group_id         = $karaf::params::service_group_id,
) {
  group { $service_group_name:
    ensure => $ensure,
    gid    => $service_group_id,
  }
  user { $service_user_name:
    ensure     => $ensure,
    uid        => $service_user_id,
    gid        => $service_user_id,
    managehome => true,
    shell      => '/bin/bash',
  }
  if $ensure == 'absent' {
    User[$service_user_name] -> Group[$service_group_name]
  }
}
