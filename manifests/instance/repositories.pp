# @api private
define karaf::instance::repositories (
  Hash[String, String] $repositories,
  Type[Resource] $x_require,
) {
  $repositories.each |$repo, $url| {
    ini_setting { "karaf instance ${name} repository ${repo}":
      ensure            => 'present',
      path              => "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.features.repos.cfg",
      setting           => $repo,
      value             => $url,
      key_val_separator => '=',
      require           => $x_require,
    }
  }
}
