# Class: play
# ===========================
#

class play (
  $config_defaults   = $play::params::config_defaults,
  $include_defaults  = $play::params::include_defaults,
  $config_template   = $play::params::config_template,
  $package_manage    = $play::params::package_manage,
  $repo_location     = $play::params::repo_location,
  $repo_trusted      = $play::params::repo_trusted,
  $package_ensure    = $play::params::package_ensure,
  $package_name      = $play::params::package_name,
  $service_enable    = $play::params::service_enable,
  $service_ensure    = $play::params::service_ensure,
  $service_manage    = $play::params::service_manage,
  $service_name      = $play::params::service_name,
  $asset_path        = $play::params::asset_path,
  $play_user         = $play::params::user,
  $play_group        = $play::params::group,
) inherits play::params {
  validate_absolute_path($config_defaults)
  validate_bool($include_defaults)
  validate_string($config_template)
  validate_bool($package_manage)
  validate_string($repo_location)
  validate_bool($repo_trusted)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_absolute_path($asset_path)
}