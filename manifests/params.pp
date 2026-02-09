# Class: play
# ===========================
# Base parameters

class play::params {
  $config_params     = lookup('play::config_params', Hash, 'hash', { 'http.port' => '9000' })
  $package_manage    = lookup('play::package_manage', Boolean, 'first', false)
  $repo_manage       = lookup('play::repo_manage', Boolean, 'first', false)
  $repo_trusted      = lookup('play::repo_trusted', Boolean, 'first', false)
  $repo_location     = lookup('play::repo_location', String, 'first', '')
  $package_ensure    = lookup('play::package_ensure', String, 'first', 'latest')
  $package_name      = lookup('play::package_name', String, 'first', 'play')
  $service_manage    = lookup('play::service_manage', Boolean, 'first', false)
  $service_enable    = lookup('play::service_enable', Boolean, 'first', true)
  $service_ensure    = lookup('play::service_ensure', String, 'first', 'running')
  $service_name      = lookup('play::service_name', String, 'first', 'play')
  $user              = lookup('play::user', String, 'first', 'play')
  $group             = lookup('play::group', String, 'first', 'play')
  $defaults          = lookup('play::defaults', String, 'first', '')
  $jvm_opts          = lookup('play::jvm_opts', Optional[String], 'first', undef)
}
