class sogo::service {
  service { $sogo::service:
    ensure => running,
    enable => true,
  }
}
