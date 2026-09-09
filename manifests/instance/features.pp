# @api private
define karaf::instance::features (
  Optional[String] $features_repository = undef,
  Optional[String] $features_boot = undef,
  Type[Resource] $x_require,
) {
  $_features_cfg = "${karaf::install::instances_dir}${name}/etc/org.apache.karaf.features.cfg"
  if $features_repository {
    $_preserve_features_script = [
      "/usr/bin/awk 'BEGIN { active=0 } { lines[NR]=\$0; if (\$0 ~ /^# featuresRepositories = /) comment=1; if (\$0 ~ /^featuresRepositories = / && !active) active=NR } END { for (i=1; i<=NR; i++) { if (i == active && !comment) print \"# \" lines[i]; print lines[i] } }'",
      "'${_features_cfg}' > '${_features_cfg}.tmp'",
      "&& /usr/bin/mv '${_features_cfg}.tmp' '${_features_cfg}'",
    ].join(' ')
    $_preserve_features_onlyif = [
      '/usr/bin/grep -q',
      "'^featuresRepositories = ' '${_features_cfg}'",
      '&&',
      '!',
      '/usr/bin/grep -q',
      "'^# featuresRepositories = ' '${_features_cfg}'",
    ].join(' ')
    exec { "karaf instance ${name} featuresRepositories preserve default":
      command => $_preserve_features_script,
      onlyif  => $_preserve_features_onlyif,
      require => $x_require,
    }
    $_update_features_script = [
      "/usr/bin/awk -v repository='${features_repository}' 'BEGIN { active=0 } { lines[NR]=\$0; if (\$0 ~ /^# featuresRepositories = /) { base_value=\$0; sub(/^# featuresRepositories = /, \"\", base_value) } if (\$0 ~ /^featuresRepositories = / && !active) active=NR } END { desired=\"featuresRepositories = \" base_value \",\" repository; for (i=1; i<=NR; i++) { if (i == active) print desired; else print lines[i] } }'",
      "'${_features_cfg}' > '${_features_cfg}.tmp'",
      "&& /usr/bin/mv '${_features_cfg}.tmp' '${_features_cfg}'",
    ].join(' ')
    $_features_current_script = [
      "/usr/bin/awk -v repository='${features_repository}' 'BEGIN { active=0 } /^# featuresRepositories = / { base_value=\$0; sub(/^# featuresRepositories = /, \"\", base_value) } /^featuresRepositories = / && !active { active=\$0; sub(/^featuresRepositories = /, \"\", active) } END { exit !(base_value != \"\" && active == base_value \",\" repository) }'",
      "'${_features_cfg}'",
    ].join(' ')
    exec { "karaf instance ${name} featuresRepositories":
      command => $_update_features_script,
      unless  => $_features_current_script,
      require => Exec["karaf instance ${name} featuresRepositories preserve default"],
    }
  }

  if $features_boot {
    $_preserve_boot_script = [
      "/usr/bin/awk 'BEGIN { active=0 } { lines[NR]=\$0; if (\$0 ~ /^# featuresBoot = /) comment=1; if (\$0 ~ /^featuresBoot = / && !active) active=NR } END { for (i=1; i<=NR; i++) { if (i == active && !comment) print \"# \" lines[i]; print lines[i] } }'",
      "'${_features_cfg}' > '${_features_cfg}.tmp'",
      "&& /usr/bin/mv '${_features_cfg}.tmp' '${_features_cfg}'",
    ].join(' ')
    $_preserve_boot_onlyif = [
      '/usr/bin/grep -q',
      "'^featuresBoot = ' '${_features_cfg}'",
      '&&',
      '!',
      '/usr/bin/grep -q',
      "'^# featuresBoot = ' '${_features_cfg}'",
    ].join(' ')
    exec { "karaf instance ${name} featuresBoot preserve default":
      command => $_preserve_boot_script,
      onlyif  => $_preserve_boot_onlyif,
      require => $x_require,
    }
    $_update_boot_script = [
      "/usr/bin/awk -v boot='${features_boot}' 'BEGIN { active=0 } { lines[NR]=\$0; if (\$0 ~ /^# featuresBoot = /) { base_value=\$0; sub(/^# featuresBoot = /, \"\", base_value) } if (\$0 ~ /^featuresBoot = / && !active) active=NR } END { desired=\"featuresBoot = \" base_value \",\" boot; for (i=1; i<=NR; i++) { if (i == active) print desired; else print lines[i] } }'",
      "'${_features_cfg}' > '${_features_cfg}.tmp'",
      "&& /usr/bin/mv '${_features_cfg}.tmp' '${_features_cfg}'",
    ].join(' ')
    $_boot_current_script = [
      "/usr/bin/awk -v boot='${features_boot}' 'BEGIN { active=0 } /^# featuresBoot = / { base_value=\$0; sub(/^# featuresBoot = /, \"\", base_value) } /^featuresBoot = / && !active { active=\$0; sub(/^featuresBoot = /, \"\", active) } END { exit !(base_value != \"\" && active == base_value \",\" boot) }'",
      "'${_features_cfg}'",
    ].join(' ')
    exec { "karaf instance ${name} featuresBoot":
      command => $_update_boot_script,
      unless  => $_boot_current_script,
      require => Exec["karaf instance ${name} featuresBoot preserve default"],
    }
  }

  file { $_features_cfg:
    ensure  => 'file',
    owner   => $karaf::service_user_name,
    group   => $karaf::service_group_name,
    mode    => '0644',
    seltype => 'usr_t',
    require => $x_require,
  }
}
