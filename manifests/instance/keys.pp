# @api private
define karaf::instance::keys (
  Type[Resource] $x_require,
) {
  if $facts['karaf']['rsa.pub'] {
    file { "${karaf::install::instances_dir}${name}/etc/keys.properties":
      ensure  => 'file',
      content => epp('karaf/keys.properties.epp', { 'keys' => { 'karaf' => "${facts['karaf']['rsa.pub']},_g_:admingroup" } }),
      require => $x_require,
    }
  }
}
