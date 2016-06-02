# Class: play
# ===========================
#

class play (
  $config            = $play::params::config,
  $config_template   = $play::params::config_template,
  $package_ensure    = $play::params::package_ensure,
  $package_name      = $play::params::package_name,
  $service_enable    = $play::params::service_enable,
  $service_ensure    = $play::params::service_ensure,
  $service_manage    = $play::params::service_manage,
  $service_name      = $play::params::service_name,
) inherits play::params {
  validate_absolute_path($config)
  validate_string($config_template)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
}