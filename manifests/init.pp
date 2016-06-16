# Class: play
# ===========================
#

class play (
  $user              = $play::params::user,
  $group             = $play::params::group,
  $home              = "/home/$user",
  $configdir         = "$home/conf",
  $package_manage    = $play::params::package_manage,
  $repo_location     = $play::params::repo_location,
  $repo_trusted      = $play::params::repo_trusted,
  $package_ensure    = $play::params::package_ensure,
  $package_name      = $play::params::package_name,
  $service_enable    = $play::params::service_enable,
  $service_ensure    = $play::params::service_ensure,
  $service_manage    = $play::params::service_manage,
  $service_name      = $play::params::service_name,
  $service_pid       = "$home/$service_name.pid",
  $config_defaults   = "/etc/$service_name/application.conf",
  $config_params     = $play::params::config_params,
  $defaults          = $play::params::defaults,
  $applicationconfig = "$configdir/application.conf",
  $loggerconfig      = "$configdir/logger.xml",
) inherits play::params {
  validate_string($user)
  validate_string($group)
  validate_absolute_path($home)
  validate_absolute_path($configdir)
  validate_bool($package_manage)
  validate_string($repo_location)
  validate_bool($repo_trusted)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_string($service_pid)
  validate_string($config_defaults)
  validate_hash($config_params)
  validate_string($defaults)
  validate_absolute_path($applicationconfig)
  validate_absolute_path($loggerconfig)
  
  include play::config
  include play::install

}
