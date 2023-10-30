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
  String[1]               $configuration_file,
  String[1]               $package,
  String[1]               $service,

  # General settings

  # S
  Optional[Integer[1]]               $workers_count = undef,
  Optional[Integer[1]]               $listen_queue_size = undef,
  Optional[String[1]]                $port = undef,
  Optional[Stdlib::Absolutepath]     $log_file = undef,
  Optional[Stdlib::Absolutepath]     $pid_file = undef,
  Optional[Integer[1]]               $watch_dog_request_timeout = undef,
  Optional[Integer[0]]               $max_upload_size = undef,
  Optional[Integer[0]]               $maximum_message_size_limit = undef,
  Optional[Integer[0]]               $mem_limit = undef,
  Optional[String[1]]                $memcached_host = undef,
  Optional[Integer[0]]               $cache_cleanup_interval = undef,
  Optional[Enum['', 'cas', 'saml2']] $authentication_type = undef,
  Optional[Boolean]                  $trust_proxy_authentication = undef,
  Optional[Sensitive[String[1]]]     $encryption_key = undef,
  Optional[String[1]]                $cas_service_url = undef,
  Optional[Boolean]                  $cas_logout_enabled = undef,
  Optional[Boolean]                  $address_book_dav_access_enabled = undef,
  Optional[Boolean]                  $calendar_dav_access_enabled = undef,
  Optional[String[1]]                $saml2_private_key_location = undef,
  Optional[String[1]]                $saml2_certificate_location = undef,
  Optional[String[1]]                $saml2_idp_metadata_location = undef,
  Optional[String[1]]                $saml2_idp_public_key_location = undef,
  Optional[String[1]]                $saml2_idp_certificate_location = undef,
  Optional[String[1]]                $saml2_login_attribute = undef,
  Optional[Boolean]                  $saml2_logout_enabled = undef,
  Optional[String[1]]                $saml2_logout_url = undef,

  # D
  Optional[String[1]]                  $time_zone = undef,
  Optional[String[1]]                  $mail_domain = undef,
  Optional[Boolean]                    $appointment_send_email_notifications = undef,
  Optional[Boolean]                    $folders_send_email_notifications = undef,
  Optional[Boolean]                    $acls_send_email_notifications = undef,
  Optional[Array[Sogo::Calendar_role]] $calendar_default_roles = undef,
  Optional[Array[Sogo::Contacts_role]] $contacts_default_roles = undef,
  Optional[Array[String[1]]]           $super_usernames = undef,

  # U
  Optional[String[1]] $language = undef,

  # D
  Optional[Boolean]   $notify_on_personal_modifications = undef,
  Optional[Boolean]   $notify_on_external_modifications = undef,
  #Optional[String[1]] $ldap_contact_info_attribute = undef,
  Optional[Boolean]   $iphone_force_all_day_transparency = undef,

  # S
  Optional[Boolean]          $enable_public_access = undef,
  Optional[Boolean]          $disable_sharing = undef,
  Optional[Boolean]          $password_change_enabled = undef,
  Optional[Array[String[1]]] $supported_languages = undef,

  # D
  Optional[Boolean]    $hide_system_email = undef,
  Optional[Integer[0]] $search_minimum_word_length = undef,

  # S
  Optional[Integer[0]] $maximum_failed_login_count = undef,
  Optional[Integer[0]] $maximum_failed_login_interval = undef,
  Optional[Integer[0]] $failed_login_block_interval = undef,
  Optional[Integer[0]] $maximum_message_submission_count = undef,
  Optional[Integer[0]] $maximum_recipient_count = undef,
  Optional[Integer[0]] $maximum_submission_interval = undef,
  Optional[Integer[0]] $message_submission_block_interval = undef,
  Optional[Integer[0]] $maximum_request_count = undef,
  Optional[Integer[0]] $maximum_request_interval = undef,
  Optional[Integer[0]] $request_block_interval = undef,
  Optional[Boolean]    $xsrf_validation_enabled = undef,

  # D
  Optional[Array[Sogo::Usersource]] $user_sources = undef,

  # S
  Optional[Boolean]          $password_recovery_enabled = undef,
  Optional[Array[String[1]]] $password_recovery_domains = undef,

  # U
  #Optional[Enum['Disabled', 'SecretQuestion', 'SecondaryEmail']] password_recovery_mode = undef,
  #password_recovery_question = undef,
  #password_recovery_question_answer = undef,
  #password_recovery_secondary_email = undef,

  # S
  Optional[Sensitive[String[1]]] $jwt_secret = undef,

  # D
  Optional[Boolean] $create_identities_disabled = undef,

  # Database Configuration
  Optional[String[1]] $profile_url = undef,
  Optional[String[1]] $folder_info_url = undef,
  Optional[String[1]] $sessions_folder_url = undef,
  Optional[String[1]] $email_alarms_folder_url = undef,
  Optional[Boolean]   $disable_organizer_event_check = undef,
  Optional[String[1]] $store_url = undef,
  Optional[String[1]] $acl_url = undef,
  Optional[String[1]] $cache_folder_url = undef,

  # Authentication using LDAP
  Optional[String[1]]  $ldap_contact_info_attribute = undef,
  Optional[String[1]]  $ldap_query_limit = undef,
  Optional[Integer[0]] $ldap_query_timeout = undef,
  Optional[Boolean]    $ldap_group_expansion_enabled = undef,

  # SMTP Server Configuration
  Optional[Enum['sendmail', 'smtp']] $mailing_mechanism = undef,
  Optional[String[1]]                $smtp_server = undef,
  Optional[Enum['PLAIN']]            $smtp_authentication_type = undef,
  Optional[Boolean]                  $smtp_master_user_enabled = undef,
  Optional[String[1]]                $smtp_master_user_username = undef,
  Optional[Sensitive[String[1]]]     $smtp_master_user_password = undef,
  Optional[String[1]]                $send_mail = undef,

  # IMAP Server Configuration
  Optional[String[1]]                  $drafts_folder_name = undef,
  Optional[String[1]]                  $sent_folder_name = undef,
  Optional[String[1]]                  $trash_folder_name = undef,
  Optional[String[1]]                  $junk_folder_name = undef,
  Optional[String[1]]                  $imap_cas_service_name = undef,
  Optional[String[1]]                  $imap_server = undef,
  Optional[String[1]]                  $sieve_server = undef,
  Optional[Enum['UTF-7', 'UTF-8']]     $sieve_folder_encoding = undef,
  Optional[Boolean]                    $mail_show_subscribed_folders_only = undef,
  Optional[Enum['rfc2086', 'rfc4314']] $imap_acl_style = undef,
  Optional[Boolean]                    $imap_acl_conforms_to_imap_ext = undef,
  Optional[Stdlib::Absolutepath]       $mail_spool_path = undef,
  Optional[Stdlib::Absolutepath]       $mime_build_mime_temp_directory = undef,
  Optional[Boolean]                    $imap4_disable_imap4_pooling = undef,
  Optional[String[1]]                  $imap4_auth_mechanism = undef,
  Optional[String[1]]                  $imap4_connection_group_id_prefix = undef,

  # Shared by SMTP and IMAP Server Configuration
  Optional[Boolean] $force_external_login_with_email = undef,

  # Web Interface Configuration
  Optional[String[1]]                             $page_title = undef,
  Optional[Stdlib::HTTPUrl]                       $help_url = undef,
  Optional[Enum['Calendar', 'Mail', 'Contacts']]  $login_module = undef,
  Optional[String[1]]                             $favicon_relative_url = undef,
  Optional[Stdlib::Absolutepath]                  $zip_path = undef,
  Optional[Float[0,1]]                            $soft_quota_ratio = undef,
  Optional[Boolean]                               $mail_use_outlook_style_replies = undef,
  Optional[Array[String[1]]]                      $mail_list_view_columns_order = undef,
  Optional[Boolean]                               $mail_add_outgoing_addresses = undef,
  Optional[Boolean]                               $mail_certificate_enabled = undef,
  Optional[String[1]]                             $selected_address_book = undef,
  Optional[Boolean]                               $external_avatars_enabled = undef,
  Optional[Boolean]                               $gravatar_enabled = undef,
  Optional[Boolean]                               $vacation_enabled = undef,
  Optional[Boolean]                               $vacation_period_enabled = undef,
  Optional[String[1]]                             $vacation_default_subject = undef,
  Optional[Stdlib::Absolutepath]                  $vacation_header_template_file = undef,
  Optional[Stdlib::Absolutepath]                  $vacation_footer_template_file = undef,
  Optional[Boolean]                               $forward_enabled = undef,
  Optional[Integer[0,2]]                          $forward_constraints = undef,
  Optional[Array[String[1]]]                      $forward_constraints_domains = undef,
  Optional[Boolean]                               $notification_enabled = undef,
  Optional[Boolean]                               $sieve_scripts_enabled = undef,
  Optional[Stdlib::Absolutepath]                  $sieve_script_header_template_file = undef,
  Optional[Stdlib::Absolutepath]                  $sieve_script_footer_template_file = undef,
  Optional[Array[String[1]]]                      $sieve_filters = undef,
  Optional[Array[Integer[1]]]                     $refresh_view_intervals = undef,
  Optional[Sogo::Refresh_view_check]              $refresh_view_check = undef,
  Optional[Boolean]                               $mail_auxiliary_user_accounts_enabled = undef,
  Optional[Enum['selected', 'personal', 'first']] $default_calendar = undef,
  Optional[Integer[0,12]]                         $day_start_time = undef,
  Optional[Integer[12,23]]                        $day_end_time = undef,
  Optional[Integer[0,6]]                          $first_day_of_week = undef,
  Optional[Sogo::First_week_of_year]              $first_week_of_year = undef,
  Optional[String[1]]                             $time_format = undef,
  Optional[Array[String[1]]]                      $calendar_categories = undef,
  Optional[Hash[String[1], String[1]]]            $calendar_categories_colors = undef,
  Optional[Sogo::Classification]                  $calendar_events_default_classification = undef,
  Optional[Sogo::Classification]                  $calendar_tasks_default_classification = undef,
  Optional[Sogo::Reminder]                        $calendar_default_reminder = undef,
  Optional[Array[Integer[0],2,2]]                 $free_busy_default_interval = undef,
  Optional[Integer[0]]                            $dav_calendar_start_time_limit = undef,
  Optional[Boolean]                               $busy_off_hours = undef,
  Optional[Enum['inline', 'attached']]            $mail_message_forwarding = undef,
  Optional[Enum['above', 'below']]                $mail_reply_placement = undef,
  Optional[Enum['above', 'below']]                $mail_signature_placement = undef,
  Optional[Boolean]                               $mail_use_signature_on_new = undef,
  Optional[Boolean]                               $mail_use_signature_on_reply = undef,
  Optional[Boolean]                               $mail_use_signature_on_forward = undef,
  Optional[Enum['text', 'html']]                  $mail_compose_message_type = undef,
  Optional[Enum['inline', 'popup']]               $mail_compose_window = undef,
  Optional[Boolean]                               $enable_email_alarms = undef,
  Optional[Array[String[1]]]                      $contacts_categories = undef,
  Optional[Array[String[1]]]                      $ui_additional_js_files = undef,
  Optional[Boolean]                               $mail_custom_from_enabled = undef,
  Optional[String[1]]                             $subscription_folder_format = undef,
  Optional[Boolean]                               $uix_additional_preferences = undef,
  Optional[Sogo::Mail_junk_settings]              $mail_junk_settings = undef,
  Optional[Boolean]                               $mail_keep_drafts_after_send = undef,

  # Multi-domains Configuration
  Optional[Hash[String[1], Sogo::Domain]] $domains = undef,
  Optional[Boolean]                       $enable_domain_based_uid = undef,
  Optional[Array[String[1]]]              $login_domains = undef,
  Optional[Array[Array[String[1]]]]       $domains_visibility = undef,
) {
  contain sogo::package
  contain sogo::config
  contain sogo::service

  Class['sogo::package']
  -> Class['sogo::config']
  ~> Class['sogo::service']
}
