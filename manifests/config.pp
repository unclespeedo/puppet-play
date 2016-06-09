# Private Class
class play::config(
  $configdir         = hiera( 'play::configdir' ),
  $applicationconfig = hiera( 'play::applicationconfig' ),
  $loggerconfig      = hiera( 'play::loggerconfig' ),
  $assetpath         = hiera( 'play::assets' ),
  $config_params     = hiera( 'play::config_params' ),
) inherits play {

  validate_absolute_path($configdir)
  validate_absolute_path($applicationconfig)
  validate_absolute_path($loggerconfig)
  validate_absolute_path($assetpath)
  validate_hash($config_params)

  file { 'assets':
    path    => $assetpath,
    ensure  => directory,
    owner   => 'liquify',
    group   => '1100',
    mode    => '750',
  }
  file { 'configurations':
    path    => $configdir,
    ensure  => directory,
    owner   => 'liquify',
    group   => '1100',
    mode    => '640'
  }
  file { 'application.conf':
    path     => $applicationconfig,
    ensure   => present,
    content  => template('play/application.conf.erb'),
  }
  file { 'logger.xml':
    path     => $loggerconfig,
    ensure   => present,
    owner    => 'liquify',
    group    => '1100',
    mode     => '640',
  }

}