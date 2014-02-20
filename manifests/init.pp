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
  $owner = "play",
  $group = "play",
  $homepath = "/opt/play"
) {

  group { "${group}":
    ensure     => present,
  }
  ->
  user { "${owner}":
    ensure     => present,
    gid        => "${group}",
    shell      => '/bin/bash',
    home       => "/home/${owner}",
  }
  ->
  file { "playappdir":
    path     => "${homepath}",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    mode     => 0550,
  }
  file { "apps":
    path     => "${homepath}/apps",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0550,
  }
  file { "conf":
    path     => "${homepath}/conf",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0550,
  }
  file { "logs":
    path     => "${homepath}/logs",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0770,
  }
  file { "pids":
    path     => "${homepath}/pids",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['playappdir'],
    mode     => 0770,
  }

  file { "logback-conf":
    path     => "${homepath}/conf/logger-conf.xml",
    ensure   => "file",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['conf'],
    mode     => 0550,
    source   => "puppet:///modules/play/logger-conf.xml",
  }
}
