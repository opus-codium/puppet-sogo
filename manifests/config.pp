class sogo::config {
  file { $sogo::configuration_file:
    ensure  => file,
    content => epp('sogo/sogo.conf.epp'),
  }
}
