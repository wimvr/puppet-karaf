# @api private
class karaf::params {
  # Default karaf version to install
  $version            = '4.4.3'

  # Default install dir
  $rootdir            = '/opt/karaf/'

  # PID file
  $pidfile            = '/opt/karaf/current/karaf.pid'

  # url to download karaf
  $karaf_zip_url      = "https://dlcdn.apache.org/karaf/\${version}/apache-karaf-\${version}.zip"

  # Should this module create the user/group.
  $manage_user        = true
  $service_user_name  = 'karaf'
  $service_user_id    = 5000
  $service_group_name = 'karaf'
  $service_group_id   = 5000

  # --------------------------------
  # Service variables.
  # --------------------------------
  $service_name       = 'karaf'
  case $facts['os']['name'] {
    'AlmaLinux', 'Rocky', 'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL', 'SLC', 'CloudLinux': {
      if versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $service_provider    = 'systemd'
      } else {
        $service_provider    = 'init'
      }
    }
    default: {
      fail("\"${module_name}\" provides no service parameters for \"${facts['os']['name']}\"")
    }
  }

  # --------------------------------
  # Java home
  # --------------------------------
  $java_home = $facts['java_default_home']

  # --------------------------------
  # Environnment variables
  # --------------------------------
  $default_env_vars   = []

  # --------------------------------
  # Karaf users definition.
  # --------------------------------
  $karaf_users_definition = {
    '_g_\\:admingroup' => 'group,admin,manager,viewer,systembundles,ssh',
    'karaf'            => 'karaf,_g_:admingroup',
  }

  # --------------------------------
  # Karaf system properties.
  # --------------------------------
  $karaf_ssh_host     = 'localhost'
  $karaf_ssh_port     = 8101

  # --------------------------------
  # Maven settings
  # --------------------------------
  $mvn_repositories = [
    'https://repo1.maven.org/maven2@id=central',
    'https://repository.apache.org/content/groups/snapshots-group@id=apache@snapshots@noreleases',
    'https://oss.sonatype.org/content/repositories/ops4j-snapshots@id=ops4j.sonatype.snapshots.deploy@snapshots@noreleases',
  ]

  $m2_settings = {}

  # ----------------------------------
  # Karaf Rmi.
  # ----------------------------------
  $karaf_rmi_registry_host = 'localhost'
  $karaf_rmi_registry_port = 1099
  $karaf_rmi_server_host = 'localhost'
  $karaf_rmi_server_port = 44444
}
