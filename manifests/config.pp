# Private Class
# @param include_defaults [Boolean] Whether to include default configuration
# @param logdir [Stdlib::Absolutepath] Directory for log files
# @param etc_default [Stdlib::Absolutepath] Path to default configuration
# @param assetsdir [Stdlib::Absolutepath] Directory for assets
# @param documentsdir [Stdlib::Absolutepath] Directory for documents
class play::config (
  Boolean                   $include_defaults  = true,
  Stdlib::Absolutepath      $logdir            = "/var/log/${play::service_name}",
  Stdlib::Absolutepath      $etc_default       = "/etc/default/${play::service_name}",
  Stdlib::Absolutepath      $assetsdir         = "${play::home}/assets",
  Stdlib::Absolutepath      $documentsdir      = "${play::home}/documents"
) inherits play {
  file { 'configurations':
    ensure => directory,
    path   => $play::configdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0640',
  }
  file { 'logs':
    ensure => directory,
    path   => $play::config::logdir,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0750',
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
    ensure  => file,
    path    => $play::applicationconfig,
    content => template('play/application.conf.erb'),
    owner   => $play::user,
    group   => $play::group,
    mode    => '0640',
  }
  file { 'logger.xml':
    ensure  => file,
    path    => $play::loggerconfig,
    content => template('play/logger.xml.erb'),
    owner   => $play::user,
    group   => $play::group,
    mode    => '0640',
  }
  file { "/home/${play::user}/heapdumps":
    ensure => directory,
    owner  => $play::user,
    group  => $play::group,
    mode   => '0700',
  }
  if $play::service_manage {
    exec { 'systemd-daemon-reload':
      command     => '/usr/bin/systemctl daemon-reload',
      refreshonly => true,
    }
    case $facts['os']['release']['major'] {
      '14.04': {
        file { 'servicefile':
          ensure  => file,
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
          ensure  => file,
          path    => "/etc/systemd/system/${play::service_name}.service",
          content => template('play/systemd.service.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Exec['systemd-daemon-reload'],
        }
        Exec['systemd-daemon-reload'] ~> Service[$play::service_name]
      }
    }
  }
}
