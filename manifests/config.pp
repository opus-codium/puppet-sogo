# @summary Manage SOGo configuration file
#
# @api private
class sogo::config {
  assert_private()

  file { $sogo::configuration_file:
    ensure  => file,
    owner   => $sogo::configuration_owner,
    group   => $sogo::configuration_group,
    mode    => $sogo::configuration_mode,
    content => epp('sogo/sogo.conf.epp'),
  }
}
