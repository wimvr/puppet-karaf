# @api private
define karaf::instance::mvn_url (
  Array[String] $mvn_repositories,
  Type[Resource] $x_require,
) {
  file { "${karaf::install::instances_dir}${name}/etc/org.ops4j.pax.url.mvn.cfg":
    ensure  => 'file',
    content => epp('karaf/org.ops4j.pax.url.mvn.cfg.epp', { 'mvn_repositories' => $mvn_repositories }),
    owner   => $karaf::service_user_name,
    group   => $karaf::service_group_name,
    seltype => 'usr_t',
    require => $x_require,
  }
}
