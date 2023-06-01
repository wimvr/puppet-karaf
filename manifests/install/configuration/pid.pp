# @api private
class karaf::install::configuration::pid (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  Stdlib::Absolutepath $pidfile,
) {
  ini_setting { "${etc_dir}config.properties-pid":
    ensure  => 'present',
    path    => "${etc_dir}config.properties",
    setting => 'karaf.pid.file',
    value   => $pidfile,
    notify  => Service[$service_name],
  }
}
