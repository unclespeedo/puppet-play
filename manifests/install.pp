#
class play::install inherits play {
  if $package_manage {
    include ::apt
    apt::source { $package_name:
      location        => "$repo_location",
      release         => 'trusty',
      repos           => 'main',
      allow_unsigned  => $repo_trusted,
    }
    if $service_manage {
      package { $package_name:
        ensure   => $package_ensure,
        notify => File['upstart.conf'],
      } 
    } else {
      package { $package_name:
        ensure   => $package_ensure,
      }
    }
    Class['apt::update'] -> Package[$package_name]
  }
}