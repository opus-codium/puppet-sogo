# @summary Manage a SOGo user source
type Sogo::Usersource = Struct[
  {
    type                    => Enum['ldap', 'sql'],
    cn_field_name           => Optional[String],
    uid_field_name          => Optional[String],
    mail_field_names        => Optional[Array[String]],
    search_field_names      => Optional[Array[String]],
    id_field_name           => Optional[String],
    bind_fields             => Optional[Array[String]],
    base_dn                 => Optional[String],
    bind_dn                 => Optional[String],
    bind_password           => Optional[String],
    can_authenticate        => Optional[Boolean],
    display_name            => Optional[String],
    filter                  => Optional[String],
    hostname                => Optional[String],
    id                      => Optional[String],
    is_address_book         => Optional[Boolean],
    user_password_algorithm => Optional[String],
    view_url                => Optional[String],
  }
]
