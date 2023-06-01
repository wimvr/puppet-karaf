# @api private
class karaf::install::configuration::users (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  Hash[String, String] $karaf_users_definition,
) {
  $karaf_users_definition.each |String $user, String $value| {
    ini_setting { "${etc_dir}users.properties-${user}":
      ensure  => 'present',
      path    => "${etc_dir}users.properties",
      setting => $user,
      value   => $value,
      before  => Service[$service_name],
    }
  }
}
