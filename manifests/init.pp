# Class: play
# ===========================
#
# @param user
#   The user that owns the Play application files and runs the service
# @param group 
#   The group that owns the Play application files and runs the service
# @param home
#   The home directory for the Play application
# @param configdir
#   The directory for the Play application configuration files
# @param package_manage
#   Whether to manage the Play package
# @param repo_manage
#   Whether to manage the Play repository
# @param repo_location
#   The location of the Play repository
# @param repo_trusted
#   Whether to trust the Play repository
# @param package_ensure
#   The ensure state of the Play package
# @param package_name
#   The name of the Play package
# @param service_enable
#   Whether to enable the Play service
# @param service_ensure
#   The ensure state of the Play service
# @param service_manage
#   Whether to manage the Play service
# @param service_name
#   The name of the Play service
# @param service_pid
#   The PID file for the Play service
# @param config_defaults
#   The default configuration file for the Play service
# @param config_params
#   The parameters for the Play configuration files
# @param defaults
#   The default values for the Play configuration files
# @param applicationconfig
#   The path to the Play application configuration file
# @param loggerconfig
#   The path to the Play logger configuration file
#
class play (
  String                    $user  = $play::params::user,
  String                    $group = $play::params::group,
  Stdlib::Absolutepath      $home               = "/home/${play::user}",
  Stdlib::Absolutepath      $configdir          = "${play::home}/conf",
  Boolean                   $package_manage     = $play::params::package_manage,
  Boolean                   $repo_manage        = $play::params::repo_manage,
  String                    $repo_location      = $play::params::repo_location,
  Boolean                   $repo_trusted       = $play::params::repo_trusted,
  String                    $package_ensure     = $play::params::package_ensure,
  String                    $package_name       = $play::params::package_name,
  Boolean                   $service_enable     = $play::params::service_enable,
  String                    $service_ensure     = $play::params::service_ensure,
  Boolean                   $service_manage     = $play::params::service_manage,
  String                    $service_name       = $play::params::service_name,
  String                    $service_pid        = "${play::home}/${play::service_name}.pid",
  String                    $config_defaults    = "/etc/${play::service_name}/application.conf",
  Hash                      $config_params      = $play::params::config_params,
  String                    $defaults           = $play::params::defaults,
  Stdlib::Absolutepath      $applicationconfig  = "${play::configdir}/application.conf",
  Stdlib::Absolutepath      $loggerconfig       = "${play::configdir}/logger.xml",
) inherits play::params {
  include play::config
  include play::install
}
