# frozen_string_literal: true

# @summary
#   Convert a data structure and output it in OpenStep plist format
Puppet::Functions.create_function(:'sogo::to_plist') do
  # @param data
  #   The data you want to convert
  # @param indent
  #   The indentation level to add to the output
  #
  # @example Output OpenStep plist to a file
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => stdlib::to_yaml($myhash),
  #   }
  #
  # @return [String] The OpenStep plist formatted document
  dispatch :to_plist do
    param 'Any', :data
    optional_param 'Integer', :indent
  end

  def to_plist(data, indent = 1)
    res = nil

    case data
    when true
      return 'YES'
    when false
      return 'NO'
    when String
      return %("#{data}")
    when Array
      res = "(\n#{data.map { |item| "  #{to_plist(item)},\n" }.join})"
    when Hash
      res = "{\n#{data.map { |key, value| "  #{normalize_key(key)} = #{to_plist(value)};\n" }.join}}"
    when Puppet::Pops::Types::PSensitiveType::Sensitive
      return to_plist(data.unwrap, indent)
    else
      return data.to_s
    end

    res.gsub("\n", "\n#{'  ' * indent}")
  end

  def normalize_key(name)
    {
      # General Preferences
      'workers_count' => 'WOWorkersCount',
      'listen_queue_size' => 'WOListenQueueSize',
      'port' => 'WOPort',
      'log_file' => 'WOLogFile',
      'pid_file' => 'WOPidFile',
      'watch_dog_request_timeout' => 'WOWatchDogRequestTimeout',
      'max_upload_size' => 'WOMaxUploadSize',
      'maximum_message_size_limit' => 'SOGoMaximumMessageSizeLimit',
      'mem_limit' => 'SxVMemLimit',
      'memcached_host' => 'SOGoMemcachedHost',
      'cache_cleanup_interval' => 'SOGoCacheCleanupInterval',
      'authentication_type' => 'SOGoAuthenticationType',
      'trust_proxy_authentication' => 'SOGoTrustProxyAuthentication',
      'encryption_key' => 'SOGoEncryptionKey',
      'cas_service_url' => 'SOGoCASServiceURL',
      'cas_logout_enabled' => 'SOGoCASLogoutEnabled',
      'address_book_dav_access_enabled' => 'SOGoAddressBookDAVAccessEnabled',
      'calendar_dav_access_enabled' => 'SOGoCalendarDAVAccessEnabled',
      'saml2_private_key_location' => 'SOGoSAML2PrivateKeyLocation',
      'saml2_certificate_location' => 'SOGoSAML2CertificateLocation',
      'saml2_idp_metadata_location' => 'SOGoSAML2IdpMetadataLocation',
      'saml2_idp_public_key_location' => 'SOGoSAML2IdpPublicKeyLocation',
      'saml2_idp_certificate_location' => 'SOGoSAML2IdpCertificateLocation',
      'saml2_login_attribute' => 'SOGoSAML2LoginAttribute',
      'saml2_logout_enabled' => 'SOGoSAML2LogoutEnabled',
      'saml2_logout_url' => 'SOGoSAML2LogoutURL',
      'time_zone' => 'SOGoTimeZone',
      'mail_domain' => 'SOGoMailDomain',
      'appointment_send_email_notifications' => 'SOGoAppointmentSendEMailNotifications',
      'folders_send_email_notifications' => 'SOGoFoldersSendEMailNotifications',
      'acls_send_email_notifications' => 'SOGoACLsSendEMailNotifications',
      'calendar_default_roles' => 'SOGoCalendarDefaultRoles',
      'contacts_default_roles' => 'SOGoContactsDefaultRoles',
      'super_usernames' => 'SOGoSuperUsernames',
      'language' => 'SOGoLanguage',
      'notify_on_personal_modifications' => 'SOGoNotifyOnPersonalModifications',
      'notify_on_external_modifications' => 'SOGoNotifyOnExternalModifications',
      'ldap_contact_info_attribute' => 'SOGoLDAPContactInfoAttribute',
      'iphone_force_all_day_transparency' => 'SOGoiPhoneForceAllDayTransparency',
      'enable_public_access' => 'SOGoEnablePublicAccess',
      'disable_sharing' => 'SOGoDisableSharing',
      'password_change_enabled' => 'SOGoPasswordChangeEnabled',
      'supported_languages' => 'SOGoSupportedLanguages',
      'hide_system_email' => 'SOGoHideSystemEMail',
      'search_minimum_word_length' => 'SOGoSearchMinimumWordLength',
      'maximum_failed_login_count' => 'SOGoMaximumFailedLoginCount',
      'maximum_failed_login_interval' => 'SOGoMaximumFailedLoginInterval',
      'failed_login_block_interval' => 'SOGoFailedLoginBlockInterval',
      'maximum_message_submission_count' => 'SOGoMaximumMessageSubmissionCount',
      'maximum_recipient_count' => 'SOGoMaximumRecipientCount',
      'maximum_submission_interval' => 'SOGoMaximumSubmissionInterval',
      'message_submission_block_interval' => 'SOGoMessageSubmissionBlockInterval',
      'maximum_request_count' => 'SOGoMaximumRequestCount',
      'maximum_request_interval' => 'SOGoMaximumRequestInterval',
      'request_block_interval' => 'SOGoRequestBlockInterval',
      'xsrf_validation_enabled' => 'SOGoXSRFValidationEnabled',
      'user_sources' => 'SOGoUserSources',
      'password_recovery_enabled' => 'SOGoPasswordRecoveryEnabled',
      'password_recovery_domains' => 'SOGoPasswordRecoveryDomains',
      'password_recovery_mode' => 'SOGoPasswordRecoveryMode',
      'password_recovery_question' => 'SOGoPasswordRecoveryQuestion',
      'password_recovery_question_answer' => 'SOGoPasswordRecoveryQuestionAnswer',
      'password_recovery_secondary_email' => 'SOGoPasswordRecoverySecondaryEmail',
      'jwt_secret' => 'SOGoJWTSecret',
      'create_identities_disabled' => 'SOGoCreateIdentitiesDisabled',

      # Authentication using LDAP
      'type' => 'type',
      'id' => 'id',
      'cn_field_name' => 'CNFieldName',
      'id_field_name' => 'IDFieldName',
      'uid_field_name' => 'UIDFieldName',
      'mail_field_names' => 'MailFieldNames',
      'search_field_names' => 'SearchFieldNames',
      'imap_host_field_name' => 'IMAPHostFieldName',
      'imap_login_field_name' => 'IMAPLoginFieldName',
      'sieve_host_field_name' => 'SieveHostFieldName',
      'base_dn' => 'baseDN',
      'kind_field_name' => 'KindFieldName',
      'multiple_bookings_field_name' => 'MultipleBookingsFieldName',
      'filter' => 'filter',
      'scope' => 'scope',
      'bind_dn' => 'bindDN',
      'bind_password' => 'bindPassword',
      'bind_as_current_user' => 'bindAsCurrentUser',
      'bind_fields' => 'bindFields',
      'lookup_fields' => 'lookupFields',
      'hostname' => 'hostname',
      'user_password_algorithm' => 'userPasswordAlgorithm',
      'can_authenticate' => 'canAuthenticate',
      'password_policy' => 'passwordPolicy',
      'update_samba_ntlm_passwords' => 'updateSambaNTLMPasswords',
      'is_address_book' => 'isAddressBook',
      'list_requires_dot' => 'listRequiresDot',
      'modules_constraints' => 'ModulesConstraints',
      'mapping' => 'mapping',
      'object_classes' => 'objectClasses',
      'group_object_classes' => 'GroupObjectClasses',
      'modifiers' => 'modifiers',
      'ab_ou' => 'abOU',

      # Authentication using LDAP
      # DUPLICATE 'ldap_contact_info_attribute' => 'SOGoLDAPContactInfoAttribute',
      'ldap_query_limit' => 'SOGoLDAPQueryLimit',
      'ldap_query_timeout' => 'SOGoLDAPQueryTimeout',
      'ldap_group_expansion_enabled' => 'SOGoLDAPGroupExpansionEnabled',

      # Database Configuration
      'profile_url' => 'SOGoProfileURL',
      'folder_info_url' => 'OCSFolderInfoURL',
      'sessions_folder_url' => 'OCSSessionsFolderURL',
      'email_alarms_folder_url' => 'OCSEMailAlarmsFolderURL',
      'disable_organizer_event_check' => 'SOGoDisableOrganizerEventCheck',
      'store_url' => 'OCSStoreURL',
      'acl_url' => 'OCSAclURL',
      'cache_folder_url' => 'OCSCacheFolderURL',

      # Authentication using SQL
      # DUPLICATE 'type' => 'type',
      # DUPLICATE 'id' => 'id',
      'view_url' => 'viewURL',
      'user_password_policy' => 'userPasswordPolicy',
      # DUPLICATE 'user_password_algorithm' => 'userPasswordAlgorithm',
      'prepend_password_scheme' => 'prependPasswordScheme',
      'key_path' => 'keyPath',
      # DUPLICATE 'can_authenticate' => 'canAuthenticate',
      # DUPLICATE 'is_address_book' => 'isAddressBook',
      'authentication_filter' => 'authenticationFilter',
      'display_name' => 'displayName',
      'login_field_names' => 'LoginFieldNames',
      # DUPLICATE 'mail_field_names' => 'MailFieldNames',
      # DUPLICATE 'search_field_names' => 'SearchFieldNames',
      # DUPLICATE 'imap_host_field_name' => 'IMAPHostFieldName',
      # DUPLICATE 'imap_login_field_name' => 'IMAPLoginFieldName',
      # DUPLICATE 'sieve_host_field_name' => 'SieveHostFieldName',
      # DUPLICATE 'kind_field_name' => 'KindFieldName',
      # DUPLICATE 'multiple_bookings_field_name' => 'MultipleBookingsFieldName',
      'domain_field_name' => 'DomainFieldName',
      # DUPLICATE 'list_requires_dot' => 'listRequiresDot',
      # DUPLICATE 'modules_constraints' => 'ModulesConstraints',

      # SMTP Server Configuration
      'mailing_mechanism' => 'SOGoMailingMechanism',
      'smtp_server' => 'SOGoSMTPServer',
      'smtp_authentication_type' => 'SOGoSMTPAuthenticationType',
      'smtp_master_user_enabled' => 'SOGoSMTPMasterUserEnabled',
      'smtp_master_user_username' => 'SOGoSMTPMasterUserUsername',
      'smtp_master_user_password' => 'SOGoSMTPMasterUserPassword',
      'send_mail' => 'WOSendMail',
      'force_external_login_with_email' => 'SOGoForceExternalLoginWithEmail',

      # IMAP Server Configuration
      'drafts_folder_name' => 'SOGoDraftsFolderName',
      'sent_folder_name' => 'SOGoSentFolderName',
      'trash_folder_name' => 'SOGoTrashFolderName',
      'junk_folder_name' => 'SOGoJunkFolderName',
      'imap_cas_service_name' => 'SOGoIMAPCASServiceName',
      'imap_server' => 'SOGoIMAPServer',
      'sieve_server' => 'SOGoSieveServer',
      'sieve_folder_encoding' => 'SOGoSieveFolderEncoding',
      'mail_show_subscribed_folders_only' => 'SOGoMailShowSubscribedFoldersOnly',
      'imap_acl_style' => 'SOGoIMAPAclStyle',
      'imap_acl_conforms_to_imap_ext' => 'SOGoIMAPAclConformsToIMAPExt',
      # DUPLICATE 'force_external_login_with_email' => 'SOGoForceExternalLoginWithEmail',
      'mail_spool_path' => 'SOGoMailSpoolPath',
      'mime_build_mime_temp_directory' => 'NGMimeBuildMimeTempDirectory',
      'imap4_disable_imap4_pooling' => 'NGImap4DisableIMAP4Pooling',
      'imap4_auth_mechanism' => 'NGImap4AuthMechanism',
      'imap4_connection_group_id_prefix' => 'NGImap4ConnectionGroupIdPrefix',

      # Web Interface Configuration
      'page_title' => 'SOGoPageTitle',
      'help_url' => 'SOGoHelpURL',
      'login_module' => 'SOGoLoginModule',
      'favicon_relative_url' => 'SOGoFaviconRelativeURL',
      'zip_path' => 'SOGoZipPath',
      'soft_quota_ratio' => 'SOGoSoftQuotaRatio',
      'mail_use_outlook_style_replies' => 'SOGoMailUseOutlookStyleReplies',
      'mail_list_view_columns_order' => 'SOGoMailListViewColumnsOrder',
      'mail_add_outgoing_addresses' => 'SOGoMailAddOutgoingAddresses',
      'mail_certificate_enabled' => 'SOGoMailCertificateEnabled',
      'selected_address_book' => 'SOGoSelectedAddressBook',
      'external_avatars_enabled' => 'SOGoExternalAvatarsEnabled',
      'gravatar_enabled' => 'SOGoGravatarEnabled',
      'vacation_enabled' => 'SOGoVacationEnabled',
      'vacation_period_enabled' => 'SOGoVacationPeriodEnabled',
      'vacation_default_subject' => 'SOGoVacationDefaultSubject',
      'vacation_header_template_file' => 'SOGoVacationHeaderTemplateFile',
      'vacation_footer_template_file' => 'SOGoVacationFooterTemplateFile',
      'forward_enabled' => 'SOGoForwardEnabled',
      'forward_constraints' => 'SOGoForwardConstraints',
      'forward_constraints_domains' => 'SOGoForwardConstraintsDomains',
      'notification_enabled' => 'SOGoNotificationEnabled',
      'sieve_scripts_enabled' => 'SOGoSieveScriptsEnabled',
      'sieve_script_header_template_file' => 'SOGoSieveScriptHeaderTemplateFile',
      'sieve_script_footer_template_file' => 'SOGoSieveScriptFooterTemplateFile',
      'sieve_filters' => 'SOGoSieveFilters',
      'refresh_view_intervals' => 'SOGoRefreshViewIntervals',
      'refresh_view_check' => 'SOGoRefreshViewCheck',
      'mail_auxiliary_user_accounts_enabled' => 'SOGoMailAuxiliaryUserAccountsEnabled',
      'default_calendar' => 'SOGoDefaultCalendar',
      'day_start_time' => 'SOGoDayStartTime',
      'day_end_time' => 'SOGoDayEndTime',
      'first_day_of_week' => 'SOGoFirstDayOfWeek',
      'first_week_of_year' => 'SOGoFirstWeekOfYear',
      'time_format' => 'SOGoTimeFormat',
      'calendar_categories' => 'SOGoCalendarCategories',
      'calendar_categories_colors' => 'SOGoCalendarCategoriesColors',
      'calendar_events_default_classification' => 'SOGoCalendarEventsDefaultClassification',
      'calendar_tasks_default_classification' => 'SOGoCalendarTasksDefaultClassification',
      'calendar_default_reminder' => 'SOGoCalendarDefaultReminder',
      'free_busy_default_interval' => 'SOGoFreeBusyDefaultInterval',
      'dav_calendar_start_time_limit' => 'SOGoDAVCalendarStartTimeLimit',
      'busy_off_hours' => 'SOGoBusyOffHours',
      'mail_message_forwarding' => 'SOGoMailMessageForwarding',
      'mail_custom_full_name' => 'SOGoMailCustomFullName',
      'mail_custom_email' => 'SOGoMailCustomEmail',
      'mail_reply_placement' => 'SOGoMailReplyPlacement',
      'mail_reply_to' => 'SOGoMailReplyTo',
      'mail_signature_placement' => 'SOGoMailSignaturePlacement',
      'mail_use_signature_on_new' => 'SOGoMailUseSignatureOnNew',
      'mail_use_signature_on_reply' => 'SOGoMailUseSignatureOnReply',
      'mail_use_signature_on_forward' => 'SOGoMailUseSignatureOnForward',
      'mail_compose_message_type' => 'SOGoMailComposeMessageType',
      'mail_compose_window' => 'SOGoMailComposeWindow',
      'enable_email_alarms' => 'SOGoEnableEMailAlarms',
      'contacts_categories' => 'SOGoContactsCategories',
      'ui_additional_js_files' => 'SOGoUIAdditionalJSFiles',
      'mail_custom_from_enabled' => 'SOGoMailCustomFromEnabled',
      'subscription_folder_format' => 'SOGoSubscriptionFolderFormat',
      'uix_additional_preferences' => 'SOGoUIxAdditionalPreferences',
      'mail_junk_settings' => 'SOGoMailJunkSettings',
      'mail_keep_drafts_after_send' => 'SOGoMailKeepDraftsAfterSend',

      # Multi-domains Configuration
      'enable_domain_based_uid' => 'SOGoEnableDomainBasedUID',
      'login_domains' => 'SOGoLoginDomains',
      'domains_visibility' => 'SOGoDomainsVisibility',

      # Creating a User Account
      'maximum_ping_interval' => 'SOGoMaximumPingInterval',
      'maximum_sync_interval' => 'SOGoMaximumSyncInterval',
      'internal_sync_interval' => 'SOGoInternalSyncInterval',
      'maximum_sync_response_size' => 'SOGoMaximumSyncResponseSize',
      'maximum_sync_window_size' => 'SOGoMaximumSyncWindowSize',
      'eas_debug_enabled' => 'SOGoEASDebugEnabled',
      'maximum_picture_size' => 'SOGoMaximumPictureSize',
      'eas_search_in_body' => 'SOGoEASSearchInBody',
      'eas_disable_ui' => 'SOGoEASDisableUI',
    }.fetch(name, name)
  end
end
