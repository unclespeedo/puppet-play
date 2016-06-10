class play::params {
  $config_params    =  ['']
  $package_manage    = false
  $repo_trusted      = true
  $package_ensure    = 'latest'
  $package_name      = 'play'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $service_name      = 'play'
  $user              = 'play'
  $group             = 'play'
}