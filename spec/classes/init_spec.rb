require 'spec_helper'

describe 'sogo' do
  let(:params) do
    {
      user_sources: user_sources,
    }
  end
  let(:user_sources) do
    []
  end

  it { should compile.with_all_deps }

  context 'ldap user source' do
    let(:user_sources) do
      [
        {
          'type'             => 'ldap',
          'cn_field_name'    => 'cn',
          'uid_field_name'   => 'uid',
          'base_dn'          => 'CN=users,dc=domain,dc=tld',
          'bind_dn'          => 'CN=sogo,CN=users,DC=domain,DC=tld',
          'bind_fields'      => %w[sAMAccountName mail],
          'bind_password'    => 'password',
          'can_authenticate' => true,
          'display_name'     => 'Public',
          'hostname'         => 'ldap://127.0.0.1:389',
          'filter'           => "mail = '*'",
          'id'               => 'directory',
          'is_address_book'  => true,
        }
      ]
    end

    it 'should produce a valid ldap user source' do
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *type = ldap;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *CNFieldName = cn;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *UIDFieldName = uid;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *baseDN = "CN=users,dc=domain,dc=tld";/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *bindDN = "CN=sogo,CN=users,DC=domain,DC=tld";/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *bindFields = \(sAMAccountName, mail\);/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *bindPassword = password;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *canAuthenticate = YES;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *displayName = Public;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(%r{^ *hostname = ldap://127.0.0.1:389;})
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *filter = "mail = '\*'";/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *id = directory;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *isAddressBook = YES;/)
    end
  end

  context 'sql user source' do
    let(:user_sources) do
      [
        {
          'type'                    => 'sql',
          'id'                      => 'directory',
          'view_url'                => 'postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view',
          'can_authenticate'        => true,
          'is_address_book'         => true,
          'user_password_algorithm' => 'md5',
        }
      ]
    end

    it 'should produce a valid sql user source' do
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *type = sql;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *id = directory;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(%r{^ *viewURL = postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view;})
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *canAuthenticate = YES;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *isAddressBook = YES;/)
      is_expected.to contain_file('/etc/sogo/sogo.conf').with_content(/^ *userPasswordAlgorithm = md5;/)
    end
  end
end
