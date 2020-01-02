class sogo (
  String                    $language = 'English',
  String                    $time_zone = 'America/Montreal',
  String                    $login_module = 'Calendar',
  Boolean                   $password_change_enabled = false,
  Array[Sogo::Usersource]   $user_sources = [],
  String                    $profile_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_user_profile',
  String                    $folder_info_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_folder_info',
  String                    $sessions_folder_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_sessions_folder',
  Boolean                   $use_custom_repo = false,
  Enum['present', 'absent'] $ensure_repository = present,
  Optional[String]          $repository_username = undef,
  Optional[String]          $repository_password = undef,
  String                    $configuration_file = undef,
  String                    $package = undef,
  String                    $service = undef,
) {
  if $use_custom_repo {
    contain sogo::repo

    Class['sogo::repo']
    -> Class['sogo::package']
  }
  contain sogo::package
  contain sogo::config
  contain sogo::service

  Class['sogo::package']
  -> Class['sogo::config']
  ~> Class['sogo::service']
}
