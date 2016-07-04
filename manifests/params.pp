class play::params {
  $config_params     =  hiera_hash('play::config_params', undef)
  $package_manage    = false
  $repo_manage       = false
  $repo_trusted      = false
  $package_ensure    = 'latest'
  $package_name      = 'play'
  $service_manage    = false
  $service_enable    = true
  $service_ensure    = 'running'
  $service_name      = 'play'
  $user              = 'play'
  $group             = 'play'
  $defaults          = ''
}
