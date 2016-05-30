# Class: play
# ===========================
#
# Full description of class play here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'play':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
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
}
