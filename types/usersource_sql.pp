# @summary Describe a SOGo SQL user source
type Sogo::Usersource_sql = Struct[
  {
    type                         => Enum['sql'],
    id                           => String[1],

    view_url                     => String[1],
    user_password_policy         => Optional[Array[Struct[label => String[1], regex => String[1]]]],
    user_password_algorithm      => Optional[String[1]],
    prepend_password_scheme      => Optional[Boolean],
    key_path                     => Optional[Stdlib::Absolutepath],
    can_authenticate             => Optional[Boolean],
    is_address_book              => Optional[Boolean],

    authentication_filter        => Optional[String[1]],
    display_name                 => Optional[String[1]],
    login_field_names            => Optional[Array[String[1]]],
    mail_field_names             => Optional[Array[String[1]]],
    search_field_names           => Optional[Array[String[1]]],
    imap_host_field_name         => Optional[String[1]],
    imap_login_field_name        => Optional[String[1]],
    sieve_host_field_name        => Optional[String[1]],
    kind_field_name              => Optional[String[1]],
    multiple_bookings_field_name => Optional[Integer[-1]],
    domain_field_name            => Optional[String[1]],
    list_requires_dot            => Optional[Boolean],
    modules_constraints          => Optional[Hash[String[1], Hash[String[1], String[1]]]],
  }
]
