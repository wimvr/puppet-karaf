# @summary Install and configure an Apache Karaf instance
#
# @param ensure
#   Specifies whether the Apache Karaf instance should be present or absent.
#
# @param ssh_host
#   Host definition of where SSH should listen.
# @param ssh_port
#   Port definition of where SSH should listen.
#
# @param rmi_registry_host
#   Host definition of where RMI registry should listen.
# @param rmi_registry_port
#   Port definition of where RMI registry should listen.
#
# @param rmi_server_host
#   Host definition of where RMI server should listen.
# @param rmi_server_port
#   Port definition of where RMI server should listen.
#
# @param log_dir
#   Directory where the log files should be stored.
#
# @param karaf_users_definition
#   Definition of Karaf users and groups.
#
# @param config
#   Additional configuration settings for the instance. Added to config.properties.
#
# @param features_repository
#   Additional features repository to add to the instance.
#
# @param features_boot
#   Additional features to add to the instance boot list.
#
# @param mvn_repositories
#   Maven repositories.
#
# @param repositories
#   Additional repositories to add to the instance.
#
define karaf::instance (
  Enum['present', 'absent'] $ensure    = 'present',
  Optional[String] $ssh_host           = $karaf::params::instance_ssh_host,
  Optional[Integer] $ssh_port          = $karaf::params::instance_ssh_port,
  Optional[String] $rmi_registry_host  = $karaf::params::instance_rmi_registry_host,
  Optional[Integer] $rmi_registry_port = $karaf::params::instance_rmi_registry_port,
  Optional[String] $rmi_server_host    = $karaf::params::instance_rmi_server_host,
  Optional[Integer] $rmi_server_port   = $karaf::params::instance_rmi_server_port,
  Optional[String] $log_dir            = $karaf::params::instance_log_dir,
  Optional[Hash[String, String]] $karaf_users_definition = $karaf::karaf_users_definition,
  Optional[Hash[String, String]] $config = $karaf::params::instance_config,
  Optional[String] $features_repository = $karaf::params::instance_features_repository,
  Optional[String] $features_boot      = $karaf::params::instance_features_boot,
  Optional[Array[String]] $mvn_repositories = $karaf::mvn_repositories,
  Optional[Hash[String, String]] $repositories = $karaf::params::instance_repositories,
) {
  if $ensure == 'present' {
    karaf::client { "instance:create ${name}":
      parameters => ['instance:create', $name],
      creates    => "${karaf::install::instances_dir}${name}/",
    }
    $_require = Karaf::Client["instance:create ${name}"]
    karaf::instance::ssh { $name:
      ssh_host  => $ssh_host,
      ssh_port  => $ssh_port,
      x_require => $_require,
    }
    karaf::instance::rmi { $name:
      rmi_registry_host => $rmi_registry_host,
      rmi_registry_port => $rmi_registry_port,
      rmi_server_host   => $rmi_server_host,
      rmi_server_port   => $rmi_server_port,
      x_require         => $_require,
    }
    karaf::instance::logging { $name:
      log_dir   => $log_dir,
      x_require => $_require,
    }
    karaf::instance::users { $name:
      karaf_users_definition => $karaf_users_definition,
      x_require              => $_require,
    }
    karaf::instance::config { $name:
      config    => $config,
      x_require => $_require,
    }
    karaf::instance::features { $name:
      features_repository => $features_repository,
      features_boot       => $features_boot,
      x_require           => $_require,
    }
    karaf::instance::mvn_url { $name:
      mvn_repositories => $mvn_repositories,
      x_require        => $_require,
    }
    karaf::instance::repositories { $name:
      repositories => $repositories,
      x_require    => $_require,
    }
    if $karaf::keyed_login {
      karaf::instance::keys { $name:
        x_require => $_require,
      }
    }
  } elsif $ensure == 'absent' {
    karaf::client { "instance:destroy ${name}":
      parameters => ['instance:destroy', $name],
      onlyif     => "/usr/bin/test -d ${karaf::install::instances_dir}${name}/",
    }
  }
}
