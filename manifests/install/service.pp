# @api private
class karaf::install::service (
  Enum['present', 'absent'] $ensure,
  Stdlib::Absolutepath $instance_root,
  Enum['init', 'systemd'] $service_provider,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
) {
  case $service_provider {
    'init': {
      class { 'karaf::install::service::service':
        ensure             => $ensure,
        instance_root      => $instance_root,
        service_name       => $service_name,
        service_user_name  => $service_user_name,
        service_group_name => $service_group_name,
      }
    }
    'systemd': {
      class { 'karaf::install::service::systemd':
        ensure             => $ensure,
        instance_root      => $instance_root,
        service_name       => $service_name,
        service_user_name  => $service_user_name,
        service_group_name => $service_group_name,
      }
    }
    default: {
      fail("\"${module_name}\" provides no service provider for \"${service_provider}\"")
    }
  }
}
