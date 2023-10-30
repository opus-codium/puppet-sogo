# frozen_string_literal: true

require 'spec_helper'

describe 'sogo' do
  test_on = {
    supported_os: [
      {
        'operatingsystem'        => 'Debian',
        'operatingsystemrelease' => '11',
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it 'produce the expected configuartion' do
        is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(<<~CONF)
          {
            /* General Preferences */

            /* Database Configuration */

            /* Authentication using LDAP */

            /* SMTP Server Configuration */

            /* IMAP Server Configuration */

            /* Web Interface Configuration */

            /* Multi-domains Configuration */

            /* Debug */
            //SOGoDebugRequests = YES;
            //SoDebugBaseURL = YES;
            //ImapDebugEnabled = YES;
            //LDAPDebugEnabled = YES;
            //PGDebugEnabled = YES;
            //MySQL4DebugEnabled = YES;
            //SOGoUIxDebugEnabled = YES;
            //WODontZipResponse = YES;
          }
        CONF
      end

      context 'with all parameters set' do
        let(:params) do
          {
            'workers_count' => 3,
            'listen_queue_size' => 5,
            'port' => '127.0.0.1:20000',
            'log_file' => '/var/log/sogo/sogo.log',
            'pid_file' => '/var/run/sogo/sogo.pid',
            'watch_dog_request_timeout' => 10,
            'max_upload_size' => 0,
            'maximum_message_size_limit' => 0,
            'mem_limit' => 384,
            'memcached_host' => 'localhost',
            'cache_cleanup_interval' => 300,
            'authentication_type' => '',
            'trust_proxy_authentication' => false,
            'encryption_key' => sensitive('secret'),
            'cas_service_url' => 'https://cas.example.com',
            'cas_logout_enabled' => false,
            'address_book_dav_access_enabled' => true,
            'calendar_dav_access_enabled' => true,
            'saml2_private_key_location' => '/path/to/key',
            'saml2_certificate_location' => '/path/to/cert',
            'saml2_idp_metadata_location' => '/path/to/idp/metadata',
            'saml2_idp_public_key_location' => '/path/to/idp/key',
            'saml2_idp_certificate_location' => '/path/to/idp/cert',
            'saml2_login_attribute' => 'login',
            'saml2_logout_enabled' => true,
            'saml2_logout_url' => 'https://saml2.example.com/logout',
            'time_zone' => 'Pacific/Tahiti',
            'mail_domain' => 'example.com',
            'appointment_send_email_notifications' => true,
            'folders_send_email_notifications' => true,
            'acls_send_email_notifications' => true,
            'calendar_default_roles' => %w[ObjectCreator PublicViewer],
            'contacts_default_roles' => ['ObjectEditor'],
            'super_usernames' => ['admin'],
            'language' => 'French',
            'notify_on_personal_modifications' => true,
            'notify_on_external_modifications' => true,
            # 'ldap_contact_info_attribute' => 'comment',
            'iphone_force_all_day_transparency' => true,
            'enable_public_access' => false,
            'disable_sharing' => false,
            'password_change_enabled' => false,
            'supported_languages' => %w[French English],
            'hide_system_email' => false,
            'search_minimum_word_length' => 4,
            'maximum_failed_login_count' => 3,
            'maximum_failed_login_interval' => 10,
            'failed_login_block_interval' => 3600,
            'maximum_message_submission_count' => 100,
            'maximum_recipient_count' => 25,
            'maximum_submission_interval' => 300,
            'message_submission_block_interval' => 3600,
            'maximum_request_count' => 10,
            'maximum_request_interval' => 30,
            'request_block_interval' => 300,
            'xsrf_validation_enabled' => true,
            'user_sources' => [
              {
                'type' => 'ldap',
                'id' => 'directory',
                'cn_field_name' => 'cn',
                'id_field_name' => 'cn',
                'uid_field_name' => 'uid',
                'mail_field_names' => ['mail'],
                'search_field_names' => %w[sn displayName cn mail telephoneNumber],
                'imap_host_field_name' => 'imap_host',
                'imap_login_field_name' => 'imap_login',
                'sieve_host_field_name' => 'sieve_host',
                'base_dn' => 'ou=%d,ou=domains,dc=example,dc=com',
                'kind_field_name' => 'kind',
                'multiple_bookings_field_name' => 2,
                'filter' => "(objectClass='mailUser' OR objectClass='mailGroup') AND accountStatus='active' AND uid <> 'alice'",
                'scope' => 'SUB',
                'bind_dn' => 'CN=sogo,DC=example,DC=com',
                'bind_password' => sensitive('secret'),
                'bind_as_current_user' => true,
                'bind_fields' => %w[sAMAccountName mail],
                'lookup_fields' => ['*', 'memberOf'],
                'hostname' => 'ldap://127.0.0.1:389',
                'user_password_algorithm' => 'ssha256',
                'can_authenticate' => true,
                'password_policy' => true,
                'update_samba_ntlm_passwords' => true,
                'is_address_book' => true,
                'list_requires_dot' => true,
                'modules_constraints' => { 'Calendar' => { 'ou' => 'employees' } },
                'mapping' => { 'facsimiletelephonenumber' => %w[fax facsimiletelephonenumber] },
                'object_classes' => ['inetOrgPerson'],
                'group_object_classes' => %w[group groupofnames groupofuniquenames posixgroup],
                'modifiers' => ['admin'],
                'ab_ou' => 'ou=addressbooks,uid=username,dc=domain',
              },
              {
                'type' => 'sql',
                'id' => 'database',
                'view_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view',
                'user_password_policy' => [
                  {
                    'label' => 'Minimum of 1 lowercase letter',
                    'regex' => '[a-z]',
                  },
                  {
                    'label' => 'Minimum of 1 uppercase letter',
                    'regex' => '[A-Z]',
                  },
                  {
                    'label' => 'Minimum of 1 digit',
                    'regex' => '[0-9]',
                  },
                  {
                    'label' => 'Minimum of 2 special symbols',
                    'regex' => '([%$&*(){}!?\\@#].*){2,}',
                  },
                  {
                    'label' => 'Minimum length of 8 characters',
                    'regex' => '.{8,}',
                  },
                ],
                'user_password_algorithm' => 'argon2i',
                'prepend_password_scheme' => true,
                'key_path' => '/path/to/key',
                'can_authenticate' => false,
                'is_address_book' => false,
                'authentication_filter' => 'deleted_at IS NULL',
                'display_name' => 'database',
                'login_field_names' => ['c_uid'],
                'mail_field_names' => ['previous_mail'],
                'search_field_names' => %w[c_cn mail],
                'imap_host_field_name' => 'imap_host',
                'imap_login_field_name' => 'imap_login',
                'sieve_host_field_name' => 'sieve_host',
                'kind_field_name' => 'kind',
                'multiple_bookings_field_name' => 2,
                'domain_field_name' => 'domain',
                'list_requires_dot' => true,
                'modules_constraints' => { 'Calendar' => { 'c_ou' => 'employees' } },
              },
            ],
            'password_recovery_enabled' => true,
            'password_recovery_domains' => ['example.com'],
            'jwt_secret' => sensitive('secret'),
            'create_identities_disabled' => true,

            # Authentication using LDAP
            'ldap_contact_info_attribute' => 'comment',
            'ldap_query_limit' => '(objectClass=inetOrgPerson)',
            'ldap_query_timeout' => 12,
            'ldap_group_expansion_enabled' => true,

            'profile_url' => 'mysql://sogo:sogo@127.0.0.1:3306/sogo/sogo_user_profile',
            'folder_info_url' => 'oracle://sogo:sogo@127.0.0.1:1526/sogo/sogo_folder_info',
            'sessions_folder_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_sessions_folder',
            'email_alarms_folder_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_alarms_folder',
            'disable_organizer_event_check' => false,
            'store_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_store',
            'acl_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_acl',
            'cache_folder_url' => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_cache_folder',

            'mailing_mechanism' => 'smtp',
            'smtp_server' => 'smtp://localhost:587/?tls=YES&tlsVerifyMode=allowInsecureLocalhost',
            'smtp_authentication_type' => 'PLAIN',
            'smtp_master_user_enabled' => true,
            'smtp_master_user_username' => 'notifications',
            'smtp_master_user_password' => sensitive('secret'),
            'send_mail' => '/usr/sbin/sendmail',
            'force_external_login_with_email' => false,

            'drafts_folder_name' => 'Drafts',
            'sent_folder_name' => 'Sent',
            'trash_folder_name' => 'Trash',
            'junk_folder_name' => 'Junk',
            'imap_cas_service_name' => 'foo',
            'imap_server' => 'imap://127.0.0.1:143/?tls=YES&tlsVerifyMode=allowInsecureLocalhost',
            'sieve_server' => 'sieve://127.0.0.14190/?tls=YES&tlsVerifyMode=allowInsecureLocalhost',
            'sieve_folder_encoding' => 'UTF-8',
            'mail_show_subscribed_folders_only' => false,
            'imap_acl_style' => 'rfc4314',
            'imap_acl_conforms_to_imap_ext' => false,
            'mail_spool_path' => '/var/spool/sogo',
            'mime_build_mime_temp_directory' => '/tmp',
            'imap4_disable_imap4_pooling' => true,
            'imap4_auth_mechanism' => 'plain',
            'imap4_connection_group_id_prefix' => '$',

            'page_title' => 'SOGo',
            'help_url' => 'https://help.example.com',
            'login_module' => 'Mail',
            'favicon_relative_url' => 'sogo.ico',
            'zip_path' => '/usr/bin/zip',
            'soft_quota_ratio' => 0.8,
            'mail_use_outlook_style_replies' => false,
            'mail_list_view_columns_order' => %w[Flagged Attachment Priority From Subject Unread Date Size],
            'mail_add_outgoing_addresses' => false,
            'mail_certificate_enabled' => true,
            'selected_address_book' => 'collected',
            'external_avatars_enabled' => true,
            'gravatar_enabled' => true,
            'vacation_enabled' => false,
            'vacation_period_enabled' => true,
            'vacation_default_subject' => 'Temporarly unavailable',
            'vacation_header_template_file' => '/etc/sogo/autoresponder.header.txt',
            'vacation_footer_template_file' => '/etc/sogo/autoresponder.footer.txt',
            'forward_enabled' => false,
            'forward_constraints' => 0,
            'forward_constraints_domains' => ['example.net'],
            'notification_enabled' => false,
            'sieve_scripts_enabled' => false,
            'sieve_script_header_template_file' => '/path/to/sieve/header',
            'sieve_script_footer_template_file' => '/path/to/sieve/footer',
            'sieve_filters' => [],
            'refresh_view_intervals' => [1, 2, 3, 5, 8, 13, 21, 44, 65],
            'refresh_view_check' => 'every_10_minutes',
            'mail_auxiliary_user_accounts_enabled' => false,
            'default_calendar' => 'selected',
            'day_start_time' => 8,
            'day_end_time' => 18,
            'first_day_of_week' => 0,
            'first_week_of_year' => 'January1',
            'time_format' => '%H:%M',
            'calendar_categories' => %w[foo bar],
            'calendar_categories_colors' => { 'foo' => '#88ffff', 'bar' => '#ff88ff' },
            'calendar_events_default_classification' => 'PUBLIC',
            'calendar_tasks_default_classification' => 'PUBLIC',
            'calendar_default_reminder' => '-PT15M',
            'free_busy_default_interval' => [7, 7],
            'dav_calendar_start_time_limit' => 0,
            'busy_off_hours' => false,
            'mail_message_forwarding' => 'inline',
            'mail_reply_placement' => 'below',
            'mail_signature_placement' => 'below',
            'mail_use_signature_on_new' => true,
            'mail_use_signature_on_reply' => true,
            'mail_use_signature_on_forward' => true,
            'mail_compose_message_type' => 'text',
            'mail_compose_window' => 'inline',
            'enable_email_alarms' => false,
            'contacts_categories' => %w[home work],
            'ui_additional_js_files' => ['extra.js'],
            'mail_custom_from_enabled' => false,
            'subscription_folder_format' => '%{FolderName} (%{UserName} <%{Email}>)',
            'uix_additional_preferences' => true,
            'mail_junk_settings' => {
              'vendor' => 'generic',
              'junkEmailAddress' => 'spam@example.com',
              'notJunkEmailAddress' => 'ham@example.com',
              'limit' => 10,
            },
            'mail_keep_drafts_after_send' => false,

            'enable_domain_based_uid' => false,
            'login_domains' => ['example.net'],
            'domains_visibility' => [['example.com', 'example.net']],
            'domains' => {
              'example.net' => {
                # General Preferences
                'time_zone' => 'Europe/Paris',
                'mail_domain' => 'example.net',
                'appointment_send_email_notifications' => false,
                'folders_send_email_notifications' => false,
                'acls_send_email_notifications' => false,
                'calendar_default_roles' => %w[],
                'contacts_default_roles' => %w[],
                'super_usernames' => ['admin'],
                'language' => 'French',
                'notify_on_personal_modifications' => false,
                'notify_on_external_modifications' => false,
                'iphone_force_all_day_transparency' => false,
                'hide_system_email' => false,
                'search_minimum_word_length' => 3,
                'user_sources' => [],
                'create_identities_disabled' => true,

                # Authentication using LDAP
                'ldap_contact_info_attribute' => 'cn',
                'ldap_query_limit' => '(objectClass=inetOrgPerson)',
                'ldap_query_timeout' => 32,
                'ldap_group_expansion_enabled' => false,

                # SMTP Server Configuration
                'mailing_mechanism' => 'smtp',
                'smtp_server' => 'smtps://domain, domain:port',
                'smtp_authentication_type' => 'PLAIN',
                'smtp_master_user_enabled' => false,
                'smtp_master_user_username' => 'admin',
                'smtp_master_user_password' => sensitive('secret'),
                # XXX'force_external_login_with_email' => true,

                # IMAP Server Configuration
                'drafts_folder_name' => 'Brouillons',
                'sent_folder_name' => 'Envoyés',
                'trash_folder_name' => 'Corbeille',
                'junk_folder_name' => 'Pouriels',
                'imap_cas_service_name' => 'foo',
                'imap_server' => 'imaps://imap.example.net:993',
                'sieve_server' => 'sieve://sieve.example.net',
                'sieve_folder_encoding' => 'UTF-8',
                'mail_show_subscribed_folders_only' => false,
                'imap_acl_style' => 'rfc2086',
                'imap_acl_conforms_to_imap_ext' => true,
                'force_external_login_with_email' => true,
                'mail_spool_path' => '/opt/spool',
                'imap4_connection_group_id_prefix' => '$',

                # Web Interface Configuration
                'login_module' => 'Mail',
                'soft_quota_ratio' => 0.9,
                'mail_use_outlook_style_replies' => false,
                'mail_list_view_columns_order' => %w[From Subject],
                'mail_add_outgoing_addresses' => false,
                'mail_certificate_enabled' => true,
                'selected_address_book' => 'collected',
                'external_avatars_enabled' => true,
                'gravatar_enabled' => true,
                'vacation_enabled' => true,
                'vacation_period_enabled' => true,
                'vacation_default_subject' => 'En vacances !',
                'vacation_header_template_file' => '/etc/sogo/autoresponder.header.txt',
                'vacation_footer_template_file' => '/etc/sogo/autoresponder.footer.txt',
                'forward_enabled' => true,
                'forward_constraints' => 1,
                'forward_constraints_domains' => ['example.net'],
                'notification_enabled' => true,
                'sieve_scripts_enabled' => true,
                'sieve_script_header_template_file' => '/path/to/sieve/header',
                'sieve_script_footer_template_file' => '/path/to/sieve/footer',
                'sieve_filters' => [],
                'refresh_view_intervals' => [1, 2, 16],
                'refresh_view_check' => 'every_minute',
                'mail_auxiliary_user_accounts_enabled' => false,
                'default_calendar' => 'personal',
                'day_start_time' => 7,
                'day_end_time' => 17,
                'first_day_of_week' => 0,
                'first_week_of_year' => 'January1',
                'time_format' => '%H:%M',
                'calendar_categories' => %w[foo bar],
                'calendar_categories_colors' => { 'foo' => '#88ffff', 'bar' => '#ffff88' },
                'calendar_events_default_classification' => 'PUBLIC',
                'calendar_tasks_default_classification' => 'PUBLIC',
                'calendar_default_reminder' => '-PT45M',
                'free_busy_default_interval' => [8, 9],
                'dav_calendar_start_time_limit' => 180,
                'busy_off_hours' => false,
                'mail_message_forwarding' => 'attached',
                'mail_reply_placement' => 'below',
                'mail_signature_placement' => 'below',
                'mail_use_signature_on_new' => true,
                'mail_use_signature_on_reply' => true,
                'mail_use_signature_on_forward' => true,
                'mail_compose_message_type' => 'html',
                'mail_compose_window' => 'inline',
                'contacts_categories' => %w[coworkers friends],
                'ui_additional_js_files' => [],
                'mail_custom_from_enabled' => false,
                'subscription_folder_format' => '%{FolderName} (%{UserName} <%{Email}>)',
                'uix_additional_preferences' => true,
                'mail_junk_settings' => {
                  'vendor' => 'generic',
                  'junkEmailAddress' => 'spam@example.net',
                  'notJunkEmailAddress' => 'ham@example.net',
                  'limit' => 10,
                },
                'mail_keep_drafts_after_send' => false,
              },
            }
          }
        end

        it 'produce the expected configuartion' do
          is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(sensitive(<<~CONF))
            {
              /* General Preferences */
              WOWorkersCount = 3;
              WOListenQueueSize = 5;
              WOPort = 127.0.0.1:20000;
              WOLogFile = /var/log/sogo/sogo.log;
              WOPidFile = /var/run/sogo/sogo.pid;
              WOWatchDogRequestTimeout = 10;
              WOMaxUploadSize = 0;
              SOGoMaximumMessageSizeLimit = 0;
              SxVMemLimit = 384;
              SOGoMemcachedHost = localhost;
              SOGoCacheCleanupInterval = 300;
              SOGoAuthenticationType = "";
              SOGoTrustProxyAuthentication = NO;
              SOGoEncryptionKey = "secret";
              SOGoCASServiceURL = https://cas.example.com;
              SOGoCASLogoutEnabled = NO;
              SOGoAddressBookDAVAccessEnabled = YES;
              SOGoCalendarDAVAccessEnabled = YES;
              SOGoSAML2PrivateKeyLocation = /path/to/key;
              SOGoSAML2CertificateLocation = /path/to/cert;
              SOGoSAML2IdpMetadataLocation = /path/to/idp/metadata;
              SOGoSAML2IdpPublicKeyLocation = /path/to/idp/key;
              SOGoSAML2IdpCertificateLocation = /path/to/idp/cert;
              SOGoSAML2LoginAttribute = login;
              SOGoSAML2LogoutEnabled = YES;
              SOGoSAML2LogoutURL = https://saml2.example.com/logout;
              SOGoTimeZone = Pacific/Tahiti;
              SOGoMailDomain = example.com;
              SOGoAppointmentSendEMailNotifications = YES;
              SOGoFoldersSendEMailNotifications = YES;
              SOGoACLsSendEMailNotifications = YES;
              SOGoCalendarDefaultRoles = (
                "ObjectCreator",
                "PublicViewer",
              );
              SOGoContactsDefaultRoles = (
                "ObjectEditor",
              );
              SOGoSuperUsernames = (
                "admin",
              );
              SOGoLanguage = French;
              SOGoNotifyOnPersonalModifications = YES;
              SOGoNotifyOnExternalModifications = YES;
              SOGoLDAPContactInfoAttribute = comment;
              SOGoiPhoneForceAllDayTransparency = YES;
              SOGoEnablePublicAccess = NO;
              SOGoDisableSharing = NO;
              SOGoPasswordChangeEnabled = NO;
              SOGoSupportedLanguages = (
                "French",
                "English",
              );
              SOGoHideSystemEMail = NO;
              SOGoSearchMinimumWordLength = 4;
              SOGoMaximumFailedLoginCount = 3;
              SOGoMaximumFailedLoginInterval = 10;
              SOGoFailedLoginBlockInterval = 3600;
              SOGoMaximumMessageSubmissionCount = 100;
              SOGoMaximumRecipientCount = 25;
              SOGoMaximumSubmissionInterval = 300;
              SOGoMessageSubmissionBlockInterval = 3600;
              SOGoMaximumRequestCount = 10;
              SOGoMaximumRequestInterval = 30;
              SOGoRequestBlockInterval = 300;
              SOGoXSRFValidationEnabled = YES;
              SOGoUserSources = (
                {
                  type = "ldap";
                  id = "directory";
                  CNFieldName = "cn";
                  IDFieldName = "cn";
                  UIDFieldName = "uid";
                  MailFieldNames = (
                    "mail",
                  );
                  SearchFieldNames = (
                    "sn",
                    "displayName",
                    "cn",
                    "mail",
                    "telephoneNumber",
                  );
                  IMAPHostFieldName = "imap_host";
                  IMAPLoginFieldName = "imap_login";
                  SieveHostFieldName = "sieve_host";
                  baseDN = "ou=%d,ou=domains,dc=example,dc=com";
                  KindFieldName = "kind";
                  MultipleBookingsFieldName = 2;
                  filter = "(objectClass='mailUser' OR objectClass='mailGroup') AND accountStatus='active' AND uid <> 'alice'";
                  scope = "SUB";
                  bindDN = "CN=sogo,DC=example,DC=com";
                  bindPassword = "secret";
                  bindAsCurrentUser = YES;
                  bindFields = (
                    "sAMAccountName",
                    "mail",
                  );
                  lookupFields = (
                    "*",
                    "memberOf",
                  );
                  hostname = "ldap://127.0.0.1:389";
                  userPasswordAlgorithm = "ssha256";
                  canAuthenticate = YES;
                  passwordPolicy = YES;
                  updateSambaNTLMPasswords = YES;
                  isAddressBook = YES;
                  listRequiresDot = YES;
                  ModulesConstraints = {
                    Calendar = {
                      ou = "employees";
                    };
                  };
                  mapping = {
                    facsimiletelephonenumber = (
                      "fax",
                      "facsimiletelephonenumber",
                    );
                  };
                  objectClasses = (
                    "inetOrgPerson",
                  );
                  GroupObjectClasses = (
                    "group",
                    "groupofnames",
                    "groupofuniquenames",
                    "posixgroup",
                  );
                  modifiers = (
                    "admin",
                  );
                  abOU = "ou=addressbooks,uid=username,dc=domain";
                },
                {
                  type = "sql";
                  id = "database";
                  viewURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view";
                  userPasswordPolicy = (
                    {
                      label = "Minimum of 1 lowercase letter";
                      regex = "[a-z]";
                    },
                    {
                      label = "Minimum of 1 uppercase letter";
                      regex = "[A-Z]";
                    },
                    {
                      label = "Minimum of 1 digit";
                      regex = "[0-9]";
                    },
                    {
                      label = "Minimum of 2 special symbols";
                      regex = "([%$&*(){}!?\\@#].*){2,}";
                    },
                    {
                      label = "Minimum length of 8 characters";
                      regex = ".{8,}";
                    },
                  );
                  userPasswordAlgorithm = "argon2i";
                  prependPasswordScheme = YES;
                  keyPath = "/path/to/key";
                  canAuthenticate = NO;
                  isAddressBook = NO;
                  authenticationFilter = "deleted_at IS NULL";
                  displayName = "database";
                  LoginFieldNames = (
                    "c_uid",
                  );
                  MailFieldNames = (
                    "previous_mail",
                  );
                  SearchFieldNames = (
                    "c_cn",
                    "mail",
                  );
                  IMAPHostFieldName = "imap_host";
                  IMAPLoginFieldName = "imap_login";
                  SieveHostFieldName = "sieve_host";
                  KindFieldName = "kind";
                  MultipleBookingsFieldName = 2;
                  DomainFieldName = "domain";
                  listRequiresDot = YES;
                  ModulesConstraints = {
                    Calendar = {
                      c_ou = "employees";
                    };
                  };
                },
              );
              SOGoPasswordRecoveryEnabled = YES;
              SOGoPasswordRecoveryDomains = (
                "example.com",
              );
              SOGoJWTSecret = "secret";
              SOGoCreateIdentitiesDisabled = YES;

              /* Database Configuration */
              SOGoProfileURL = "mysql://sogo:sogo@127.0.0.1:3306/sogo/sogo_user_profile";
              OCSFolderInfoURL = "oracle://sogo:sogo@127.0.0.1:1526/sogo/sogo_folder_info";
              OCSSessionsFolderURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_sessions_folder";
              OCSEMailAlarmsFolderURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_alarms_folder";
              SOGoDisableOrganizerEventCheck = NO;
              OCSStoreURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_store";
              OCSAclURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_acl";
              OCSCacheFolderURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_cache_folder";

              /* Authentication using LDAP */
              SOGoLDAPContactInfoAttribute = "comment";
              SOGoLDAPQueryLimit = "(objectClass=inetOrgPerson)";
              SOGoLDAPQueryTimeout = 12;
              SOGoLDAPGroupExpansionEnabled = YES;

              /* SMTP Server Configuration */
              SOGoMailingMechanism = smtp;
              SOGoSMTPServer = "smtp://localhost:587/?tls=YES&tlsVerifyMode=allowInsecureLocalhost";
              SOGoSMTPAuthenticationType = PLAIN;
              SOGoSMTPMasterUserEnabled = YES;
              SOGoSMTPMasterUserUsername = "notifications";
              SOGoSMTPMasterUserPassword = "secret";
              WOSendMail = "/usr/sbin/sendmail";
              SOGoForceExternalLoginWithEmail = NO;

              /* IMAP Server Configuration */
              SOGoDraftsFolderName = Drafts;
              SOGoSentFolderName = Sent;
              SOGoTrashFolderName = Trash;
              SOGoJunkFolderName = Junk;
              SOGoIMAPCASServiceName = "foo";
              SOGoIMAPServer = "imap://127.0.0.1:143/?tls=YES&tlsVerifyMode=allowInsecureLocalhost";
              SOGoSieveServer = "sieve://127.0.0.14190/?tls=YES&tlsVerifyMode=allowInsecureLocalhost";
              SOGoSieveFolderEncoding = UTF-8;
              SOGoMailShowSubscribedFoldersOnly = NO;
              SOGoIMAPAclStyle = rfc4314;
              SOGoIMAPAclConformsToIMAPExt = NO;
              SOGoForceExternalLoginWithEmail = NO;
              SOGoMailSpoolPath = /var/spool/sogo;
              NGMimeBuildMimeTempDirectory = /tmp;
              NGImap4DisableIMAP4Pooling = YES;
              NGImap4AuthMechanism = plain;
              NGImap4ConnectionGroupIdPrefix = "$";

              /* Web Interface Configuration */
              SOGoPageTitle = "SOGo";
              SOGoHelpURL = "https://help.example.com";
              SOGoLoginModule = Mail;
              SOGoFaviconRelativeURL = sogo.ico;
              SOGoZipPath = /usr/bin/zip;
              SOGoSoftQuotaRatio = 0.8;
              SOGoMailUseOutlookStyleReplies = NO;
              SOGoMailListViewColumnsOrder = (
                "Flagged",
                "Attachment",
                "Priority",
                "From",
                "Subject",
                "Unread",
                "Date",
                "Size",
              );
              SOGoMailAddOutgoingAddresses = NO;
              SOGoMailCertificateEnabled = YES;
              SOGoSelectedAddressBook = collected;
              SOGoExternalAvatarsEnabled = YES;
              SOGoGravatarEnabled = YES;
              SOGoVacationEnabled = NO;
              SOGoVacationPeriodEnabled = YES;
              SOGoVacationDefaultSubject = "Temporarly unavailable";
              SOGoVacationHeaderTemplateFile = /etc/sogo/autoresponder.header.txt;
              SOGoVacationFooterTemplateFile = /etc/sogo/autoresponder.footer.txt;
              SOGoForwardEnabled = NO;
              SOGoForwardConstraints = 0;
              SOGoForwardConstraintsDomains = (
                "example.net",
              );
              SOGoNotificationEnabled = NO;
              SOGoSieveScriptsEnabled = NO;
              SOGoSieveScriptHeaderTemplateFile = /path/to/sieve/header;
              SOGoSieveScriptFooterTemplateFile = /path/to/sieve/footer;
              SOGoSieveFilters = (
              );
              SOGoRefreshViewIntervals = (
                1,
                2,
                3,
                5,
                8,
                13,
                21,
                44,
                65,
              );
              SOGoRefreshViewCheck = every_10_minutes;
              SOGoMailAuxiliaryUserAccountsEnabled = NO;
              SOGoDefaultCalendar = selected;
              SOGoDayStartTime = 8;
              SOGoDayEndTime = 18;
              SOGoFirstDayOfWeek = 0;
              SOGoFirstWeekOfYear = January1;
              SOGoTimeFormat = "%H:%M";
              SOGoCalendarCategories = (
                "foo",
                "bar",
              );
              SOGoCalendarCategoriesColors = {
                foo = "#88ffff";
                bar = "#ff88ff";
              };
              SOGoCalendarEventsDefaultClassification = PUBLIC;
              SOGoCalendarTasksDefaultClassification = PUBLIC;
              SOGoCalendarDefaultReminder = -PT15M;
              SOGoFreeBusyDefaultInterval = (
                7,
                7,
              );
              SOGoDAVCalendarStartTimeLimit = 0;
              SOGoBusyOffHours = NO;
              SOGoMailMessageForwarding = inline;
              SOGoMailReplyPlacement = below;
              SOGoMailSignaturePlacement = below;
              SOGoMailUseSignatureOnNew = YES;
              SOGoMailUseSignatureOnReply = YES;
              SOGoMailUseSignatureOnForward = YES;
              SOGoMailComposeMessageType = text;
              SOGoMailComposeWindow = inline;
              SOGoEnableEMailAlarms = NO;
              SOGoContactsCategories = (
                "home",
                "work",
              );
              SOGoUIAdditionalJSFiles = (
                "extra.js",
              );
              SOGoMailCustomFromEnabled = NO;
              SOGoSubscriptionFolderFormat = "%{FolderName} (%{UserName} <%{Email}>)";
              SOGoUIxAdditionalPreferences = YES;
              SOGoMailJunkSettings = {
                vendor = "generic";
                junkEmailAddress = "spam@example.com";
                notJunkEmailAddress = "ham@example.com";
                limit = 10;
              };
              SOGoMailKeepDraftsAfterSend = NO;

              /* Multi-domains Configuration */
              SOGoEnableDomainBasedUID = NO;
              SOGoLoginDomains = (
                "example.net",
              );
              SOGoDomainsVisibility = (
                (
                  "example.com",
                  "example.net",
                ),
              );
              domains = {
                example.net = {
                  SOGoTimeZone = "Europe/Paris";
                  SOGoMailDomain = "example.net";
                  SOGoAppointmentSendEMailNotifications = NO;
                  SOGoFoldersSendEMailNotifications = NO;
                  SOGoACLsSendEMailNotifications = NO;
                  SOGoCalendarDefaultRoles = (
                  );
                  SOGoContactsDefaultRoles = (
                  );
                  SOGoSuperUsernames = (
                    "admin",
                  );
                  SOGoLanguage = "French";
                  SOGoNotifyOnPersonalModifications = NO;
                  SOGoNotifyOnExternalModifications = NO;
                  SOGoiPhoneForceAllDayTransparency = NO;
                  SOGoHideSystemEMail = NO;
                  SOGoSearchMinimumWordLength = 3;
                  SOGoUserSources = (
                  );
                  SOGoCreateIdentitiesDisabled = YES;
                  SOGoLDAPContactInfoAttribute = "cn";
                  SOGoLDAPQueryLimit = "(objectClass=inetOrgPerson)";
                  SOGoLDAPQueryTimeout = 32;
                  SOGoLDAPGroupExpansionEnabled = NO;
                  SOGoMailingMechanism = "smtp";
                  SOGoSMTPServer = "smtps://domain, domain:port";
                  SOGoSMTPAuthenticationType = "PLAIN";
                  SOGoSMTPMasterUserEnabled = NO;
                  SOGoSMTPMasterUserUsername = "admin";
                  SOGoSMTPMasterUserPassword = "secret";
                  SOGoDraftsFolderName = "Brouillons";
                  SOGoSentFolderName = "Envoyés";
                  SOGoTrashFolderName = "Corbeille";
                  SOGoJunkFolderName = "Pouriels";
                  SOGoIMAPCASServiceName = "foo";
                  SOGoIMAPServer = "imaps://imap.example.net:993";
                  SOGoSieveServer = "sieve://sieve.example.net";
                  SOGoSieveFolderEncoding = "UTF-8";
                  SOGoMailShowSubscribedFoldersOnly = NO;
                  SOGoIMAPAclStyle = "rfc2086";
                  SOGoIMAPAclConformsToIMAPExt = YES;
                  SOGoForceExternalLoginWithEmail = YES;
                  SOGoMailSpoolPath = "/opt/spool";
                  NGImap4ConnectionGroupIdPrefix = "$";
                  SOGoLoginModule = "Mail";
                  SOGoSoftQuotaRatio = 0.9;
                  SOGoMailUseOutlookStyleReplies = NO;
                  SOGoMailListViewColumnsOrder = (
                    "From",
                    "Subject",
                  );
                  SOGoMailAddOutgoingAddresses = NO;
                  SOGoMailCertificateEnabled = YES;
                  SOGoSelectedAddressBook = "collected";
                  SOGoExternalAvatarsEnabled = YES;
                  SOGoGravatarEnabled = YES;
                  SOGoVacationEnabled = YES;
                  SOGoVacationPeriodEnabled = YES;
                  SOGoVacationDefaultSubject = "En vacances !";
                  SOGoVacationHeaderTemplateFile = "/etc/sogo/autoresponder.header.txt";
                  SOGoVacationFooterTemplateFile = "/etc/sogo/autoresponder.footer.txt";
                  SOGoForwardEnabled = YES;
                  SOGoForwardConstraints = 1;
                  SOGoForwardConstraintsDomains = (
                    "example.net",
                  );
                  SOGoNotificationEnabled = YES;
                  SOGoSieveScriptsEnabled = YES;
                  SOGoSieveScriptHeaderTemplateFile = "/path/to/sieve/header";
                  SOGoSieveScriptFooterTemplateFile = "/path/to/sieve/footer";
                  SOGoSieveFilters = (
                  );
                  SOGoRefreshViewIntervals = (
                    1,
                    2,
                    16,
                  );
                  SOGoRefreshViewCheck = "every_minute";
                  SOGoMailAuxiliaryUserAccountsEnabled = NO;
                  SOGoDefaultCalendar = "personal";
                  SOGoDayStartTime = 7;
                  SOGoDayEndTime = 17;
                  SOGoFirstDayOfWeek = 0;
                  SOGoFirstWeekOfYear = "January1";
                  SOGoTimeFormat = "%H:%M";
                  SOGoCalendarCategories = (
                    "foo",
                    "bar",
                  );
                  SOGoCalendarCategoriesColors = {
                    foo = "#88ffff";
                    bar = "#ffff88";
                  };
                  SOGoCalendarEventsDefaultClassification = "PUBLIC";
                  SOGoCalendarTasksDefaultClassification = "PUBLIC";
                  SOGoCalendarDefaultReminder = "-PT45M";
                  SOGoFreeBusyDefaultInterval = (
                    8,
                    9,
                  );
                  SOGoDAVCalendarStartTimeLimit = 180;
                  SOGoBusyOffHours = NO;
                  SOGoMailMessageForwarding = "attached";
                  SOGoMailReplyPlacement = "below";
                  SOGoMailSignaturePlacement = "below";
                  SOGoMailUseSignatureOnNew = YES;
                  SOGoMailUseSignatureOnReply = YES;
                  SOGoMailUseSignatureOnForward = YES;
                  SOGoMailComposeMessageType = "html";
                  SOGoMailComposeWindow = "inline";
                  SOGoContactsCategories = (
                    "coworkers",
                    "friends",
                  );
                  SOGoUIAdditionalJSFiles = (
                  );
                  SOGoMailCustomFromEnabled = NO;
                  SOGoSubscriptionFolderFormat = "%{FolderName} (%{UserName} <%{Email}>)";
                  SOGoUIxAdditionalPreferences = YES;
                  SOGoMailJunkSettings = {
                    vendor = "generic";
                    junkEmailAddress = "spam@example.net";
                    notJunkEmailAddress = "ham@example.net";
                    limit = 10;
                  };
                  SOGoMailKeepDraftsAfterSend = NO;
                };
              };

              /* Debug */
              //SOGoDebugRequests = YES;
              //SoDebugBaseURL = YES;
              //ImapDebugEnabled = YES;
              //LDAPDebugEnabled = YES;
              //PGDebugEnabled = YES;
              //MySQL4DebugEnabled = YES;
              //SOGoUIxDebugEnabled = YES;
              //WODontZipResponse = YES;
            }
          CONF
        end
      end
    end
  end
end
