# @api private
class karaf::install::configuration::m2_settings (
  String $user,
  String $group,
  Stdlib::Absolutepath $home_dir,
  Boolean $manage_user,
  Struct[{ Optional[servers] => Array, Optional[mirrors] => Array }] $m2_settings,
) {
  if $manage_user {
    $_require = User[$user]
  } else {
    $_require = undef
  }
  file { "${home_dir}/.m2/":
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    seltype => 'user_home_t',
    require => $_require,
  }
  file { "${home_dir}/.m2/settings.xml":
    ensure  => 'file',
    owner   => $user,
    group   => $group,
    mode    => '0640',
    seltype => 'user_home_t',
    content => epp('karaf/m2-settings.xml.epp', { 'm2_settings' => $m2_settings }),
  }
}
