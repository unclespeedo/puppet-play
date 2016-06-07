class play::params {
  $config_defaults   = '/etc/play/application.conf'
  $include_defaults  = 'true'
  $config_template   = 'play/application.conf.erb'
  $package_manage    = 'false'
  $repo_trusted      = 'true'
  $package_ensure    = 'latest'
  $package_name      = 'play'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $service_name      = 'play'
  $asset_path        = '/etc/play/assets'
}