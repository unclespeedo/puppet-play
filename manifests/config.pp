# Private Class
class play::config(
  $include_defaults  = true,
  $config_defaults   = $play::config_defaults,
  $applicationconfig = "${play::configdir}/application.conf",
  $loggerconfig      = "${play::configdir}/logger.xml",
  $logdir            = "/var/log/$service_name",
  $config_params     = $play::config_params,
) inherits play {
  validate_bool($include_defaults)
  validate_absolute_path($config_defaults)
  validate_absolute_path($applicationconfig)
  validate_absolute_path($loggerconfig)
  validate_absolute_path($logdir)
  validate_hash($config_params)

  file { 'configurations':
    path    => $configdir,
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '640'
  }
  file { 'logs':
    path    => $logdir,
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '750'
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
    owner    => $user,
    group    => $group,
    mode     => '640',
  }
  file { 'logger.xml':
    path     => $loggerconfig,
    ensure   => present,
    content  => template('play/logger.xml.erb'),
    owner    => $user,
    group    => $group,
    mode     => '640',
  }

}
