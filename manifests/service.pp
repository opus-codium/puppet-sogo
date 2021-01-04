# @summary Manage the SOGo service
class sogo::service {
  assert_private()

  service { $sogo::service:
    ensure => running,
    enable => true,
  }
}
