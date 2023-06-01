# @api private
class karaf::install::configuration::mvn_url (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  String $service_user_name,
  String $service_group_name,
  Array[String] $mvn_repositories,
) {
  file { "${etc_dir}org.ops4j.pax.url.mvn.cfg":
    ensure  => 'file',
    owner   => $service_user_name,
    group   => $service_group_name,
    content => epp('karaf/org.ops4j.pax.url.mvn.cfg.epp', { 'mvn_repositories' => $mvn_repositories }),
    before  => Service[$service_name],
  }
}
