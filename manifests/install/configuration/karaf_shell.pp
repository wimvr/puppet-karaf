# @api private
class karaf::install::configuration::karaf_shell (
  Stdlib::Absolutepath $etc_dir,
  String $service_name,
  String $karaf_ssh_host,
  Integer $karaf_ssh_port,
) {
  ini_setting { "${etc_dir}org.apache.karaf.shell.cfg-sshHost":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.shell.cfg",
    setting => 'sshHost',
    value   => $karaf_ssh_host,
    notify  => Service[$service_name],
  }
  ini_setting { "${etc_dir}org.apache.karaf.shell.cfg-sshPort":
    ensure  => 'present',
    path    => "${etc_dir}org.apache.karaf.shell.cfg",
    setting => 'sshPort',
    value   => $karaf_ssh_port,
    notify  => Service[$service_name],
  }
}
