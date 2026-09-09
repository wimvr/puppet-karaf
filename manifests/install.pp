# @api private
class karaf::install (
  Enum['present', 'absent'] $ensure,
  String $version,
  Stdlib::Absolutepath $rootdir,
  Stdlib::Absolutepath $java_home,
  String $karaf_zip_url,
  Boolean $manage_user,
  Stdlib::Absolutepath $home_dir,
  Boolean $keyed_login,
  String $service_user_name,
  Integer $service_user_id,
  String $service_group_name,
  Integer $service_group_id,
  String $service_name,
  Hash[String, String] $default_env_vars,
  Stdlib::Absolutepath $pidfile,
  Enum['systemd', 'init'] $service_provider,
  Array[String] $mvn_repositories,
  Struct[{ Optional[servers] => Array, Optional[mirrors] => Array }] $m2_settings,
  Hash[String, String] $karaf_users_definition,
  String $karaf_ssh_host,
  Integer $karaf_ssh_port,
  String $karaf_rmi_registry_host,
  Integer $karaf_rmi_registry_port,
  String $karaf_rmi_server_host,
  Integer $karaf_rmi_server_port,
) {
  if $manage_user {
    class { 'karaf::install::user':
      ensure             => $ensure,
      home_dir           => $home_dir,
      service_user_name  => $service_user_name,
      service_user_id    => $service_user_id,
      service_group_name => $service_group_name,
      service_group_id   => $service_group_id,
    }
  }

  $instance_root = "${rootdir}current/"
  $install_dir = "${rootdir}apache-karaf-${version}/"
  if $ensure == 'absent' {
    file { $instance_root:
      ensure  => 'absent',
      recurse => true,
    }
    file { $install_dir:
      ensure  => 'absent',
      recurse => true,
    }
  } else {
    $bin_dir = "${install_dir}bin/"
    $etc_dir = "${install_dir}etc/"
    $instances_dir = "${install_dir}instances/"
    file { $rootdir:
      ensure => 'directory',
    }
    file { $install_dir:
      ensure => 'directory',
      owner  => $service_user_name,
      group  => $service_group_name,
    }
    archive { "/tmp/apache-karaf-${version}.zip":
      source       => $karaf_zip_url.regsubst("\\\${version}", $version, 'G'),
      extract      => true,
      extract_path => $rootdir,
      creates      => "${install_dir}system/",
      user         => $service_user_name,
      group        => $service_group_name,
    }
    file { $instance_root:
      ensure => 'link',
      target => $install_dir,
      owner  => $service_user_name,
      group  => $service_group_name,
    }

    class { 'karaf::install::configuration':
      bin_dir                 => $bin_dir,
      etc_dir                 => $etc_dir,
      home_dir                => $home_dir,
      manage_user             => $manage_user,
      service_name            => $service_name,
      service_user_name       => $service_user_name,
      service_group_name      => $service_group_name,
      java_home               => $java_home,
      default_env_vars        => $default_env_vars,
      pidfile                 => $pidfile,
      mvn_repositories        => $mvn_repositories,
      m2_settings             => $m2_settings,
      karaf_users_definition  => $karaf_users_definition,
      karaf_ssh_host          => $karaf_ssh_host,
      karaf_ssh_port          => $karaf_ssh_port,
      karaf_rmi_registry_host => $karaf_rmi_registry_host,
      karaf_rmi_registry_port => $karaf_rmi_registry_port,
      karaf_rmi_server_host   => $karaf_rmi_server_host,
      karaf_rmi_server_port   => $karaf_rmi_server_port,
    }

    if $keyed_login {
      ssh_keygen { $service_user_name:
        type => 'rsa',
        home => $home_dir,
      }
    }
  }

  class { 'karaf::install::service':
    ensure             => $ensure,
    instance_root      => $instance_root,
    service_name       => $service_name,
    service_user_name  => $service_user_name,
    service_group_name => $service_group_name,
    service_provider   => $service_provider,
  }
}
