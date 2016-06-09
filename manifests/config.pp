# Private Class
class play::config(
  $include_defaults  = true,
  $config_defaults   = $play::config_defaults,
  $applicationconfig = "${play::configdir}/application.conf",
  $loggerconfig      = "${play::configdir}/logger.xml",
  $config_params     = $play::config_params,
) inherits play {
  validate_bool($include_defaults)
  validate_absolute_path($config_defaults)
  validate_absolute_path($applicationconfig)
  validate_absolute_path($loggerconfig)
  validate_hash($config_params)

  file { 'configurations':
    path    => $configdir,
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '640'
  }
  file { 'assets':
    path    => $assetsdir,
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '750',
  }

  file { 'application.conf':
    path     => $applicationconfig,
    ensure   => present,
    content  => template('play/application.conf.erb'),
    owner   => $user,
    group   => $group,
    mode    => '640',
  }
  file { 'logger.xml':
    path    => $loggerconfig,
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '640',
  }

}