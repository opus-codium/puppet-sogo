# sogo

#### Table of Contents

<!-- vim-markdown-toc GFM -->

* [Module Description](#module-description)
* [Usage](#usage)
  * [Beginning with sogo](#beginning-with-sogo)
  * [Serving SOGo through Apache](#serving-sogo-through-apache)

<!-- vim-markdown-toc -->

## Module Description

The sogo module lets you use Puppet to manage the [SOGo](https://sogo.nu/) groupware.

## Usage

### Beginning with sogo

SOGo needs a PostgreSQL database to store it's data.  This database is not managed by the module.  It is recommended to configure the database and sogo in a profile in your control-repo:

```puppet
$db_hostname = 'localhost'
$db_database = 'sogo'
$db_username = 'sogo'
$db_password = 'secret'

postgresql::server::db { $db_database:
user     => $db_username,
password => postgresql::postgresql_password($db_username, $db_password),
before   => Class['sogo::service'],
}

class { 'sogo':
  language     => 'French',
  time_zone    => 'Pacific/Tahiti',
  user_sources => [
    {
      type             => 'ldap',
      cn_field_name    => 'cn',
      uid_field_name   => 'uid',
      mail_field_names => [
        'mail',
        'mailAlternateAddress',
      ],
      id_field_name    => 'cn',
      bind_fields      => [
        'uid',
        'mail',
      ],
      base_dn          => 'ou=people,dc=example,dc=com',
      bind_dn          => 'cn=apache,ou=services,dc=example,dc=com',
      bind_password    => 'secret',
      can_authenticate => true,
      display_name     => 'LDAP Addressbook',
      hostname         => 'ldap://ldap.example.com:389/????!StartTLS',
      id               => 'public',
      is_address_book  => true,
    },
  ],
  profile_url             => "postgresql://${db_username}:${db_password}@${db_hostname}/${db_database}/sogo_user_profile",
  folder_info_url         => "postgresql://${db_username}:${db_password}@${db_hostname}/${db_database}/sogo_folder_info",
  sessions_folder_url     => "postgresql://${db_username}:${db_password}@${db_hostname}/${db_database}/sogo_sessions_folder",
}
```

### Serving SOGo through Apache

With the above configuration, SOGo is reachable at http://127.0.0.1:20000/SOGo.  You can configure Apache to act as a proxy to expose the service to the Internet:

```puppet
  apache::vhost { 'sogo.example.com':
    port            => 443,
    ssl             => true,
    mdomain         => true,
    manage_docroot  => flase,
    docroot         => '/usr/local/GNUstep/Local/Library/SOGo',
    aliases         => [
      {
        alias => '/SOGo.woa/WebServerResources/',
        path  => '/usr/local/GNUstep/Local/Library/SOGo/WebServerResources/',
      },
      {
        alias => '/SOGo/WebServerResources/',
        path  => '/usr/local/GNUstep/Local/Library/SOGo/WebServerResources/',
      },
    ],
    directories     => [
      {
        path            => '/usr/local/GNUstep/Local/Library/SOGo',
        expires_active  => 'on',
        expires_default => 'access plus 1 year',
        allow_override  => 'None',
      },
    ],
    headers         => [
      'unset Content-Security-Policy',
    ],
    proxy_pass      => [
      {
        path  => '/SOGo',
        url   => 'http://127.0.0.1:20000/SOGo',
        retry => 0,
      },
    ],
    request_headers => [
      'set "x-webobjects-server-port" "443"',
      'set "x-webobjects-server-name" "sogo.example.com"',
      'set "x-webobjects-server-url" "https://sogo.example.com"',
      'set "x-webobjects-server-protocol" "HTTP/1.0"',
    ],
    rewrites        => [
      {
        rewrite_rule => [
          '^/$ /SOGo [R=301]',
          '^/.well-known/caldav/?$ /SOGo/dav [R=301]',
          '^/.well-known/carddav/?$ /SOGo/dav [R=301]',
        ],
      }
    ],
  }
```
