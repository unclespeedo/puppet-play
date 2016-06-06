#
class play::install inherits play {

  if $play::package_manage {
    include ::apt
    apt::source { $play::package_name:
      location  => "$play::repo_location",
    }
    package { $play::package_name:
      ensure => $play::package_ensure,
    }
    Class['apt::update'] -> Package[$play::package_name]
  }
}