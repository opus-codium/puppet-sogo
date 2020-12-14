# @summary Manage SOGo
#
# @param language Default language used in the Web interface
# @param time_zone Default time zone for users
# @param login_module Module to show after login
# @param password_change_enabled Allow or not users to change their passwords from SOGo
# @param user_sources LDAP and/or SQL sources used for authentication and global address books
# @param profile_url Database URL so that SOGo can retrieve user profiles
# @param folder_info_url Database URL so that SOGo can retrieve the location of user folders
# @param sessions_folder_url Database URL so that SOGo can store and retrieve secured user sessions information
# @param configuration_file Path to SOGo configuration file
# @param package Package name
# @param service Ensure parameter for the SOGo package
class sogo (
  String                  $configuration_file,
  String                  $package,
  String                  $service,
  String                  $language = 'English',
  String                  $time_zone = 'America/Montreal',
  String                  $login_module = 'Calendar',
  Boolean                 $password_change_enabled = false,
  Array[Sogo::Usersource] $user_sources = [],
  String                  $profile_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_user_profile',
  String                  $folder_info_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_folder_info',
  String                  $sessions_folder_url = 'postgresql://sogo:sogo@localhost:5432/sogo/sogo_sessions_folder',
) {
  contain sogo::package
  contain sogo::config
  contain sogo::service

  Class['sogo::package']
  -> Class['sogo::config']
  ~> Class['sogo::service']
}
