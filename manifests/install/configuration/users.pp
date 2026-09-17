# @api private
class karaf::install::configuration::users (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
  Hash[String, String] $karaf_users_definition,
) {
  file { "${etc_dir}users.properties":
    ensure  => 'file',
    content => epp('karaf/users.properties.epp', { 'users' => $karaf_users_definition }),
    owner   => $service_user_name,
    group   => $service_group_name,
    seltype => 'usr_t',
    before  => Service[$service_name],
  }
}
