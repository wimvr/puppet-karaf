# @api private
class karaf::install::configuration::karaf_management (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  String $karaf_rmi_registry_host,
  Integer $karaf_rmi_registry_port,
  String $karaf_rmi_server_host,
  Integer $karaf_rmi_server_port,
) {
  ini_setting { "${etc_dir}org.apache.karaf.management.cfg-rmiRegistryHost":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.management.cfg",
    setting => 'rmiRegistryHost',
    value   => $karaf_rmi_registry_host,
    notify  => Service[$service_name],
  }
  ini_setting { "${etc_dir}org.apache.karaf.management.cfg-rmiRegistryPort":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.management.cfg",
    setting => 'rmiRegistryPort',
    value   => $karaf_rmi_registry_port,
    notify  => Service[$service_name],
  }
  ini_setting { "${etc_dir}org.apache.karaf.management.cfg-rmiServerHost":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.management.cfg",
    setting => 'rmiServerHost',
    value   => $karaf_rmi_server_host,
    notify  => Service[$service_name],
  }
  ini_setting { "${etc_dir}org.apache.karaf.management.cfg-rmiServerPort":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.management.cfg",
    setting => 'rmiServerPort',
    value   => $karaf_rmi_server_port,
    notify  => Service[$service_name],
  }
}
