# @api private
class karaf::install::configuration::setenv (
  Stdlib::Absolutepath $bin_dir,
  String $service_name,
  Stdlib::Absolutepath $java_home,
  Hash[String, String] $default_env_vars,
) {
  file_line { "${bin_dir}setenv-JAVA_HOME":
    path   => "${bin_dir}setenv",
    line   => "export JAVA_HOME=\"${java_home}\"",
    match  => '^export JAVA_HOME=',
    before => Service[$service_name],
  }
  $default_env_vars.each |$key, $value| {
    file_line { "${bin_dir}setenv-${key}":
      path   => "${bin_dir}setenv",
      line   => "export ${key}=${value}",
      match  => "^export ${key}=",
      before => Service[$service_name],
    }
  }
}
