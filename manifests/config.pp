# Private Class
class play::config inherits play {
  file { 'play-assets':
    path    => "$play::asset_path",
    ensure  => directory,
    owner   => 'liquify',
    group   => '1100',
    mode    => '750',
  }

}