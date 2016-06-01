# Class: play
# ===========================
#

class play (
  $user     = $::play::params::user,
  $group    = $::play::params::group,
  $homepath = $::play::params::homepath,
) inherits play::params {
  validate_string($user)
  validate_string($group)
  validate_absolute_path($homepath)
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

}
