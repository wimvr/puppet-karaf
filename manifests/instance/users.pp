# @api private
define karaf::instance::users (
  Hash[String, String] $karaf_users_definition,
  Type[Resource] $x_require,
) {
  file { "${karaf::install::instances_dir}${name}/etc/users.properties":
    ensure  => 'file',
    content => epp('karaf/users.properties.epp', { 'users' => $karaf_users_definition }),
    require => $x_require,
  }
}
