# @api private
class karaf::install::configuration::m2_settings (
  String $user,
  String $group,
  Struct[{ Optional[servers] => Array, Optional[mirrors] => Array }] $m2_settings,
) {
  file { "/home/${user}/.m2/":
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    seltype => 'user_home_t',
  }
  file { "/home/${user}/.m2/settings.xml":
    ensure  => 'file',
    owner   => $user,
    group   => $group,
    mode    => '0640',
    seltype => 'user_home_t',
    content => epp('karaf/m2-settings.xml.epp', { 'm2_settings' => $m2_settings }),
  }
}
