# Private Class
class play::config(
  $include_defaults  = true,
  $logdir            = "/var/log/$service_name",
  $etc_default       = "/etc/default/$service_name",
  $assetsdir         = "$home/assets",
  $documentsdir      = "$home/documents",
) inherits play {
  validate_bool($include_defaults)
  validate_absolute_path($config_defaults)
  validate_absolute_path($logdir)
  validate_hash($config_params)
  validate_absolute_path($assetsdir)

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
  file { 'documents':
    path    => $documentsdir,
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
    notify  => Service["$service_name"]
  }
  file { 'logger.xml':
    path     => $loggerconfig,
    ensure   => present,
    content  => template('play/logger.xml.erb'),
    owner    => $user,
    group    => $group,
    mode     => '640',
  }
  if $service_manage {
    file { 'upstart.conf':
      path     => "/etc/init/${service_name}.conf",
      ensure   => present,
      content  => template('play/upstart.conf.erb'),
      owner    => $user,
      group    => $group,
      mode     => '750',
      notify   => Service["$service_name"],
    }
  }
}
