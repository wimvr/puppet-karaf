define karaf::instance::logging (
  String $log_dir,
  Type[Resource] $x_require,
) {
  $logconfig = "${karaf::install::instances_dir}${name}/etc/org.ops4j.pax.logging.cfg"
  ini_setting { "karaf instance ${name} log4j2.appender.rolling.fileName":
    path    => $logconfig,
    setting => 'log4j2.appender.rolling.fileName',
    value   => "${log_dir}/karaf.log",
    require => $x_require,
  }
  ini_setting { "karaf instance ${name} log4j2.appender.rolling.filePattern":
    path    => $logconfig,
    setting => 'log4j2.appender.rolling.filePattern',
    value   => "${log_dir}/karaf.log.%i",
    require => $x_require,
  }
  ini_setting { "karaf instance ${name} log4j2.appender.audit.fileName":
    path    => $logconfig,
    setting => 'log4j2.appender.audit.fileName',
    value   => "${log_dir}/security.log",
    require => $x_require,
  }
  ini_setting { "karaf instance ${name} log4j2.appender.audit.filePattern":
    path    => $logconfig,
    setting => 'log4j2.appender.audit.filePattern',
    value   => "${log_dir}/security.log.%i",
    require => $x_require,
  }
}
