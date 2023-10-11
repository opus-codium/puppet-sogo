# @summary Describe a SOGo domain
type Sogo::Domain = Struct[
  {
    # General Preferences
    Optional[time_zone]                              => String[1],
    Optional[mail_domain]                            => String[1],
    Optional[appointment_send_email_notifications]   => Boolean,
    Optional[folders_send_email_notifications]       => Boolean,
    Optional[acls_send_email_notifications]          => Boolean,
    Optional[calendar_default_roles]                 => Array[Sogo::Calendar_role],
    Optional[contacts_default_roles]                 => Array[Sogo::Contacts_role],
    Optional[super_usernames]                        => Array[String[1]],
    Optional[language]                               => String[1],
    Optional[notify_on_personal_modifications]       => Boolean,
    Optional[notify_on_external_modifications]       => Boolean,
    Optional[ldap_contact_info_attribute]            => String[1],
    Optional[iphone_force_all_day_transparency]      => Boolean,
    Optional[hide_system_email]                      => Boolean,
    Optional[search_minimum_word_length]             => Integer[0],
    Optional[user_sources]                           => Array[Sogo::Usersource],
    Optional[create_identities_disabled]             => Boolean,

    # Authentication using LDAP
    Optional[ldap_contact_info_attribute]            => String[1],
    Optional[ldap_query_limit]                       => String[1],
    Optional[ldap_query_timeout]                     => Integer[0],
    Optional[ldap_group_expansion_enabled]           => Boolean,

    # SMTP Server Configuration
    Optional[mailing_mechanism]                      => String[1],
    Optional[smtp_server]                            => String[1],
    Optional[smtp_authentication_type]               => String[1],
    Optional[smtp_master_user_enabled]               => Boolean,
    Optional[smtp_master_user_username]              => String[1],
    Optional[smtp_master_user_password]              => Sensitive[String[1]],
    Optional[force_external_login_with_email]        => Boolean,

    # IMAP Server Configuration
    Optional[drafts_folder_name]                     => String[1],
    Optional[sent_folder_name]                       => String[1],
    Optional[trash_folder_name]                      => String[1],
    Optional[junk_folder_name]                       => String[1],
    Optional[imap_cas_service_name]                  => String[1],
    Optional[imap_server]                            => String[1],
    Optional[sieve_server]                           => String[1],
    Optional[sieve_folder_encoding]                  => Enum['UTF-7', 'UTF-8'],
    Optional[mail_show_subscribed_folders_only]      => Boolean,
    Optional[imap_acl_style]                         => Enum['rfc2086', 'rfc4314'],
    Optional[imap_acl_conforms_to_imap_ext]          => Boolean,
    #Optional[force_external_login_with_email]       => Boolean,
    Optional[mail_spool_path]                        => String[1],
    Optional[imap4_connection_group_id_prefix]       => String[1],

    # Web Interface Configuration
    Optional[login_module]                           => String[1],
    Optional[soft_quota_ratio]                       => Float[0, 1],
    Optional[mail_use_outlook_style_replies]         => Boolean,
    Optional[mail_list_view_columns_order]           => Array[String[1]],
    Optional[mail_add_outgoing_addresses]            => Boolean,
    Optional[mail_certificate_enabled]               => Boolean,
    Optional[selected_address_book]                  => String[1],
    Optional[external_avatars_enabled]               => Boolean,
    Optional[gravatar_enabled]                       => Boolean,
    Optional[vacation_enabled]                       => Boolean,
    Optional[vacation_period_enabled]                => Boolean,
    Optional[vacation_default_subject]               => String[1],
    Optional[vacation_header_template_file]          => Stdlib::Absolutepath,
    Optional[vacation_footer_template_file]          => Stdlib::Absolutepath,
    Optional[forward_enabled]                        => Boolean,
    Optional[forward_constraints]                    => Integer[0, 2],
    Optional[forward_constraints_domains]            => Array[String[1]],
    Optional[notification_enabled]                   => Boolean,
    Optional[sieve_scripts_enabled]                  => Boolean,
    Optional[sieve_script_header_template_file]      => Stdlib::Absolutepath,
    Optional[sieve_script_footer_template_file]      => Stdlib::Absolutepath,
    Optional[sieve_filters]                          => Array[String[1]],
    Optional[refresh_view_intervals]                 => Array[Integer[0]],
    Optional[refresh_view_check]                     => Sogo::Refresh_view_check,
    Optional[mail_auxiliary_user_accounts_enabled]   => Boolean,
    Optional[default_calendar]                       => Enum['selected','personal','first'],
    Optional[day_start_time]                         => Integer[0,12],
    Optional[day_end_time]                           => Integer[12,23],
    Optional[first_day_of_week]                      => Integer[0,6],
    Optional[first_week_of_year]                     => Enum['January1','First4DayWeek','FirstFullWeek'],
    Optional[time_format]                            => String[1],
    Optional[calendar_categories]                    => Array[String[1]],
    Optional[calendar_categories_colors]             => Hash[String[1], String[1]],
    Optional[calendar_events_default_classification] => Enum['PUBLIC','CONFIDENTIAL','PRIVATE'],
    Optional[calendar_tasks_default_classification]  => Enum['PUBLIC','CONFIDENTIAL','PRIVATE'],
    Optional[calendar_default_reminder]              => Sogo::Reminder,
    Optional[free_busy_default_interval]             => Array[Integer[0], 2, 2],
    Optional[dav_calendar_start_time_limit]          => Integer[0],
    Optional[busy_off_hours]                         => Boolean,
    Optional[mail_message_forwarding]                => String[1],
    Optional[mail_reply_placement]                   => String[1],
    Optional[mail_signature_placement]               => String[1],
    Optional[mail_use_signature_on_new]              => Boolean,
    Optional[mail_use_signature_on_reply]            => Boolean,
    Optional[mail_use_signature_on_forward]          => Boolean,
    Optional[mail_compose_message_type]              => Enum['text', 'html'],
    Optional[mail_compose_window]                    => Enum['inline', 'popup'],
    Optional[enable_email_alarms]                    => Boolean,
    Optional[contacts_categories]                    => Array[String[1]],
    Optional[ui_additional_js_files]                 => Array[String[1]],
    Optional[mail_custom_from_enabled]               => Boolean,
    Optional[subscription_folder_format]             => String[1],
    Optional[uix_additional_preferences]             => Boolean,
    Optional[mail_junk_settings]                     => Sogo::Mail_junk_settings,
    Optional[mail_keep_drafts_after_send]            => Boolean,
  }
]
