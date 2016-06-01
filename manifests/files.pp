class play::files {
  file { 'playappdir':
    ensure => 'directory',
    path   => $homepath,
    owner  => $user,
    group  => $group,
    mode   => '0775',
  }
  file { 'playlogs':
    ensure  => 'directory',
    path    => "${homepath}/logs",
    owner   => $user,
    group   => $group,
    require => File['playappdir'],
    mode    => '0775',
  }
  file { 'playpids':
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
}