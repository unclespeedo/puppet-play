class play::params {
  $config            = '/etc/play/application.conf'
  $config_template   = 'play/application.conf.erb'
  $package_manage    = 'false'
  $package_ensure    = 'latest'
  $package_name      = 'play'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $service_name      = 'play'
}