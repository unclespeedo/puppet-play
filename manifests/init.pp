# == Class: play
#
# Full description of class play here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class play (
  $user     = $::play::params::user,
  $group    = $::play::params::group,
  $homepath = $::play::params::homepath,
) inherits play::params {
  validate_string($user)
  validate_string($group)
  validate_absolute_path($home)
} ->
{

  group { $group:
    ensure     => present,
  }
  ->
  user { $user:
    ensure => present,
    gid    => $group,
    home   => $homepath,
  }
  ->
  file { 'playappdir':
    ensure => 'directory',
    path   => $homepath,
    owner  => $user,
    group  => $group,
    mode   => '0775',
  }
  file { 'apps':
    ensure  => 'directory',
    path    => "${homepath}/apps",
    owner   => $user,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'conf':
    ensure  => 'directory',
    path    => "${homepath}/conf",
    owner   => $user,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'logs':
    ensure  => 'directory',
    path    => "${homepath}/logs",
    owner   => $user,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'pids':
    ensure  => 'directory',
    path    => "${homepath}/pids",
    owner   => $user,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { [ "${homepath}/cache", "${homepath}/cache/zip"] :
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  if $::lsbdistid == 'ubuntu' {
    package {'unzip':
      ensure => installed,
    }~>
    exec {'apt-get update':
      command     => '/usr/bin/apt-get update',
      refreshonly => true,
    }
  }

}
