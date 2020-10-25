#
class play::install inherits play {
  if $play::package_manage {
    if $play::repo_manage {
      include ::apt
      apt::source { $play::package_name:
        location       => $play::repo_location,
        release        => 'trusty',
        repos          => 'main',
        allow_unsigned => $play::repo_trusted,
      }
    }
    if $play::service_manage {
      package { $play::package_name:
        ensure => $play::package_ensure,
        notify => File['servicefile'],
      }
      case $facts['os']['release']['major'] {
        '16.04': {
          service { $play::service_name:
            enable    => $play::service_enable,
            hasstatus => false,
            require   => Package[$play::package_name],
            subscribe => File['application.conf']
          }
        }
        '14.04': {
          service { $play::service_name:
            ensure    => $play::service_ensure,
            enable    => $play::service_enable,
            hasstatus => false,
            require   => Package[$play::package_name],
            subscribe => File['application.conf']
          }
        }
        default: {
          notify('Sorry, $play::service_name is not supported on your distribution.')
        }
      }
    } else {
      package { $play::package_name:
        ensure   => $play::package_ensure,
        provider => apt,
      }
    }
    Class['apt::update'] -> Package[$play::package_name]
  }
}
