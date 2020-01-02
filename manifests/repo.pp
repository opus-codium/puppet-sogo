class sogo::repo {
  if $sogo::repository_username and $sogo::repository_password {
    $location = "https://${sogo::repository_username}:${sogo::repository_password}@packages.inverse.ca/SOGo/release/3/debian/"
  } else {
    $location = 'https://packages.inverse.ca/SOGo/nightly/3/debian/'
  }

  apt::source { 'inverse_ca':
    ensure   => $sogo::ensure_repository,
    comment  => 'Inverse repository for SOGo',
    location => $location,
    release  => $facts['lsbdistcodename'],
    repos    => $facts['lsbdistcodename'],
    key      => {
      id     => 'FE9E84327B18FF82B0378B6719CDA6A9810273C4',
      server => 'pgp.mit.edu',
    },
  }
}
