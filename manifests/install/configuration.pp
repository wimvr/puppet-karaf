# @api private
class karaf::install::configuration (
  Stdlib::Absolutepath $bin_dir,
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
  Stdlib::Absolutepath $java_home,
  Hash[String, String] $default_env_vars,
  Stdlib::Absolutepath $pidfile,
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
  class { 'karaf::install::configuration::m2_settings':
    user        => $service_user_name,
    group       => $service_group_name,
    m2_settings => $m2_settings,
  }

  class { 'karaf::install::configuration::karaf_management':
    etc_dir                 => $etc_dir,
    service_name            => $service_name,
    karaf_rmi_registry_host => $karaf_rmi_registry_host,
    karaf_rmi_registry_port => $karaf_rmi_registry_port,
    karaf_rmi_server_host   => $karaf_rmi_server_host,
    karaf_rmi_server_port   => $karaf_rmi_server_port,
  }

  class { 'karaf::install::configuration::karaf_shell':
    etc_dir        => $etc_dir,
    service_name   => $service_name,
    karaf_ssh_host => $karaf_ssh_host,
    karaf_ssh_port => $karaf_ssh_port,
  }

  class { 'karaf::install::configuration::mvn_url':
    etc_dir            => $etc_dir,
    service_name       => $service_name,
    service_user_name  => $service_user_name,
    service_group_name => $service_group_name,
    mvn_repositories   => $mvn_repositories,
  }

  class { 'karaf::install::configuration::pid':
    etc_dir      => $etc_dir,
    service_name => $service_name,
    pidfile      => $pidfile,
  }

  class { 'karaf::install::configuration::setenv':
    bin_dir          => $bin_dir,
    service_name     => $service_name,
    java_home        => $java_home,
    default_env_vars => $default_env_vars,
  }

  class { 'karaf::install::configuration::users':
    etc_dir                => $etc_dir,
    service_name           => $service_name,
    karaf_users_definition => $karaf_users_definition,
  }
}
