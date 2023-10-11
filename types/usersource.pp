# @summary Describe a SOGo user source
type Sogo::Usersource = Variant[
  Sogo::Usersource_ldap,
  Sogo::Usersource_sql,
]
