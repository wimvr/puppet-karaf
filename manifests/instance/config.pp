# @api private
define karaf::instance::config (
  Hash[String, String] $config,
  Type[Resource] $x_require,
) {
  $config.each |String $config_key, String $config_value| {
    ini_setting { "karaf instance ${name} config ${config_key}":
      ensure  => 'present',
      path    => "${karaf::install::instances_dir}${name}/etc/config.properties",
      setting => $config_key,
      value   => $config_value,
      require => $x_require,
    }
  }
}
