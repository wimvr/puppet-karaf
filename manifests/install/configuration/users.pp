# @api private
class karaf::install::configuration::users (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  Hash[String, String] $karaf_users_definition,
) {
  file { "${etc_dir}users.properties":
    ensure  => 'file',
    content => epp('karaf/users.properties.epp', { 'users' => $karaf_users_definition }),
    owner   => $karaf::service_user_name,
    group   => $karaf::service_group_name,
    seltype => 'usr_t',
    before  => Service[$service_name],
  }
}
