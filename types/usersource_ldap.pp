# @summary Describe a SOGo LDAP user source
type Sogo::Usersource_ldap = Struct[
  {
    type                         => Enum['ldap'],
    id                           => Optional[String[1]],

    cn_field_name                => Optional[String[1]],
    id_field_name                => Optional[String[1]],
    uid_field_name               => Optional[String[1]],
    mail_field_names             => Optional[Array[String[1]]],
    search_field_names           => Optional[Array[String[1]]],
    imap_host_field_name         => Optional[String[1]],
    imap_login_field_name        => Optional[String[1]],
    sieve_host_field_name        => Optional[String[1]],
    base_dn                      => Optional[String[1]],
    kind_field_name              => Optional[String[1]],
    multiple_bookings_field_name => Optional[Integer[-1]],
    filter                       => Optional[String[1]],
    scope                        => Optional[Enum['BASE', 'ONE', 'SUB']],
    bind_dn                      => Optional[String[1]],
    bind_password                => Optional[Sensitive[String[1]]],
    bind_as_current_user         => Optional[Boolean],
    bind_fields                  => Optional[Array[String]],
    lookup_fields                => Optional[Array[String[1]]],
    hostname                     => Optional[String[1]],
    # port
    # encryption
    user_password_algorithm      => Optional[String[1]],
    can_authenticate             => Optional[Boolean],
    password_policy              => Optional[Boolean],
    update_samba_ntlm_passwords  => Optional[Boolean],
    is_address_book              => Optional[Boolean],
    display_name                 => Optional[String[1]],
    list_requires_dot            => Optional[Boolean],
    modules_constraints          => Optional[Hash[String[1], Hash[String[1], String[1]]]],
    mapping                      => Optional[Hash[String[1], Array[String[1]]]],
    object_classes               => Optional[Array[String[1]]],
    group_object_classes         => Optional[Array[String[1]]],
    modifiers                    => Optional[Array[String[1]]],
    ab_ou                        => Optional[String[1]],

    # DS
    ldap_contact_info_attribute  => Optional[String[1]],
    ldap_query_limit             => Optional[Integer[1]],
    ldap_query_timeout           => Optional[Integer[0]],
    ldap_group_expansion_enabled => Optional[Boolean],
  }
]
