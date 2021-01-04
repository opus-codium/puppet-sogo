# @summary Manage the SOGo package
class sogo::package {
  assert_private()

  package { $sogo::package:
    ensure => installed,
  }
}
