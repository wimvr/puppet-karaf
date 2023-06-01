# @summary Install and configure Apache Karaf
#
# @example
#   class { 'karaf': }
#
# @param ensure
#   Specifies whether Apache Karaf should be installed.
#
# @param version
#   Version of Apache Karaf to install.
#
# @param rootdir
#   Root directory in which to install Apache Karaf.
#
# @param karaf_zip_url
#   URL where the Karaf ZIP can be downloaded. '${version}' will be replaced withe the configured version.
#
# @param manage_user
#   Should this module create Unix user and group.
#
# @param service_user_name
#   As which Unix user to run Karaf.
#
# @param service_user_id
#   UID to use to create the Unix user.
#
# @param service_group_name
#   As which Unix group to run Karaf.
#
# @param service_group_id
#   GID to use to create the Unix group.
#
# @param service_name
#   Name of the Unix service to install.
#
# @param service_provider
#   Is the system using init.d or systemd to run system services.
#
# @param java_home
#   Home of Java installation.
#
# @param default_env_vars
#   Default environment variables to set.
#
# @param karaf_users_definition
#   Definition of Karaf users and groups.
#
# @param karaf_ssh_host
#   Host definition of where SSH should listen.
#
# @param karaf_ssh_port
#   Port definition of where SSH should listen.
#
# @param mvn_repositories
#   Maven repositories.
#
# @param m2_settings
#   Maven settings.
#
# @param karaf_rmi_registry_host
#   Host definition of where RMI registry should listen.
#
# @param karaf_rmi_registry_port
#   Port definition of where RMI registry should listen.
#
# @param karaf_rmi_server_host
#   Host definition of where RMI server should listen.
#
# @param karaf_rmi_server_port
#   Port definition of where RMI server should listen.
#
# @param pidfile
#   Where to store PID file.
#
class karaf (
  Enum['present', 'absent'] $ensure            = 'present',
  String $version                              = $karaf::params::version,
  Stdlib::Absolutepath $rootdir                = $karaf::params::rootdir,
  String $karaf_zip_url                        = $karaf::params::karaf_zip_url,
  Boolean $manage_user                         = $karaf::params::manage_user,
  String $service_user_name                    = $karaf::params::service_user_name,
  Integer $service_user_id                     = $karaf::params::service_user_id,
  String $service_group_name                   = $karaf::params::service_group_name,
  Integer $service_group_id                    = $karaf::params::service_group_id,
  String $service_name                         = $karaf::params::service_name,
  Enum['systemd', 'init'] $service_provider    = $karaf::params::service_provider,
  Stdlib::Absolutepath $java_home              = $karaf::params::java_home,
  Hash[String, String] $default_env_vars       = $karaf::params::default_env_vars,
  Hash[String, String] $karaf_users_definition = $karaf::params::karaf_users_definition,
  String $karaf_ssh_host                       = $karaf::params::karaf_ssh_host,
  Integer $karaf_ssh_port                      = $karaf::params::karaf_ssh_port,
  Array[String] $mvn_repositories              = $karaf::params::mvn_repositories,
  Struct[{ Optional[servers] => Array, Optional[mirrors] => Array }] $m2_settings = $karaf::params::m2_settings,
  String $karaf_rmi_registry_host              = $karaf::params::karaf_rmi_registry_host,
  Integer $karaf_rmi_registry_port             = $karaf::params::karaf_rmi_registry_port,
  String $karaf_rmi_server_host                = $karaf::params::karaf_rmi_server_host,
  Integer $karaf_rmi_server_port               = $karaf::params::karaf_rmi_server_port,
  Stdlib::Absolutepath $pidfile                = $karaf::params::pidfile,
) inherits karaf::params {
  class { 'karaf::install':
    ensure                  => $ensure,
    version                 => $version,
    rootdir                 => $rootdir,
    java_home               => $java_home,
    karaf_zip_url           => $karaf_zip_url,
    manage_user             => $manage_user,
    service_user_name       => $service_user_name,
    service_user_id         => $service_user_id,
    service_group_name      => $service_group_name,
    service_group_id        => $service_group_id,
    service_name            => $service_name,
    default_env_vars        => $default_env_vars,
    pidfile                 => $pidfile,
    service_provider        => $service_provider,
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
}
