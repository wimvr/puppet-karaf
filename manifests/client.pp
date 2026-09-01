# @api public
#
# @param bin_dir
#   Directory containing the Karaf client executable.
#
# @param parameters
#   Arguments passed to the Karaf client command.
#
# @param creates
#   File whose existence prevents the command from running.
#
# @param unless
#   Command that prevents the client command from running when successful.
#
# @param onlyif
#   Command that allows the client command to run when successful.
define karaf::client (
  Stdlib::Absolutepath $bin_dir = $karaf::install::bin_dir,
  Array[String] $parameters = [$name],
  Optional[String] $creates = undef,
  Optional[String] $unless = undef,
  Optional[String] $onlyif = undef,
) {
  $command = "/usr/bin/echo ${stdlib::shell_escape(join($parameters, ' '))} | ${bin_dir}client -b"

  exec { "karaf client ${name}":
    command => $command,
    creates => $creates,
    unless  => $unless,
    onlyif  => $onlyif,
    user    => $karaf::service_user_name,
    group   => $karaf::service_group_name,
    cwd     => $karaf::rootdir,
  }
}
