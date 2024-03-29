# Private Class
class play::config(
  $include_defaults  = true,
  $logdir            = "/var/log/${play::service_name}",
  $etc_default       = "/etc/default/${play::service_name}",
  $assetsdir         = "${play::home}/assets",
  $documentsdir      = "${play::home}/documents"
) inherits play {
  validate_bool($play::config::include_defaults)
  validate_absolute_path($play::config_defaults)
  validate_absolute_path($play::config::logdir)
  validate_hash($play::config_params)
  validate_absolute_path($play::config::assetsdir)

  file { 'configurations':
    ensure => directory,
    path   => $play::configdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0640'
  }
  file { 'logs':
    ensure => directory,
    path   => $play::config::logdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0750'
  }
  file { 'assets':
    ensure => directory,
    path   => $play::config::assetsdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0750',
  }
  file { 'documents':
    ensure => directory,
    path   => $play::config::documentsdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0750',
  }
  file { 'application.conf':
    ensure  => present,
    path    => $play::applicationconfig,
    content => template('play/application.conf.erb'),
    owner   => $play::user,
    group   => $play::group,
    mode    => '0640'
  }
  file { 'logger.xml':
    ensure  => present,
    path    => $play::loggerconfig,
    content => template('play/logger.xml.erb'),
    owner   => $play::user,
    group   => $play::group,
    mode    => '0640',
  }
  if $play::service_manage {
    case $facts['os']['release']['major'] {
      '14.04': {
        file { 'servicefile':
          ensure  => present,
          path    => "/etc/init/${play::service_name}.conf",
          content => template('play/upstart.conf.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Service[$play::service_name],
        }
      }
      default: {
        file { 'servicefile':
          ensure  => present,
          path    => "/etc/systemd/system/${play::service_name}.service",
          content => template('play/systemd.service.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Service[$play::service_name],
        }
      }
    }
  }
}

