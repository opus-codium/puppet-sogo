#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(URI.open('https://www.sogo.nu/files/docs/SOGoInstallationGuide.html'))

@transformations = %w[acl cas cn dav dn eas id imap js jwt ldap ntlm ou smtp ui uid url xsrf].sort.reverse.to_h { |item| [item.gsub('', '_'), "_#{item}_"] }

def normaline_parameter(name)
  name = "#{name}_".
         sub(%r{^(NG|OCS|SOGo|SxV|WO)}, '_').
         gsub(%r{[[:upper:]]}, '_\0').
         downcase

  @transformations.each do |key, value|
    name.gsub!(key, value)
  end

  name.gsub(%r{_a_c_ls_}, '_acls_').
    gsub('_e_mail_', '_email_').
    gsub('_i_m_a_p4_', '_imap4_').
    gsub('_i_phone_', '_iphone_').
    gsub('_s_a_m_l2_', '_saml2_').
    gsub('_u_ix_', '_uix_').
    gsub('_u_ix_', '_uix_').
    sub(%r{^_*}, '').
    sub(%r{_*$}, '')
end

def output_parameter(parameter)
  return if parameter =~ %r{\(deprecated\)}

  parameter = parameter.sub("\n", '')
  parameter = parameter.sub(%r{ +\(.*\)$}, '')

  if @new_section
    puts
    puts "      # #{@section}"
    @new_section = false
  end

  if @known_parameters.include?(parameter)
    puts "      # DUPLICATE '#{normaline_parameter(parameter)}' => '#{parameter}',"
  else
    puts "      '#{normaline_parameter(parameter)}' => '#{parameter}',"
    @known_parameters << parameter
  end
end

@known_parameters = []
doc.css('table').each do |table|
  @section = table.xpath('./preceding::h3').last.content.gsub(%r{^[[:digit:].]+ }, '')
  @new_section = true

  table.css('tr').each do |line|
    fields = line.css('td')
    if fields.size == 3
      output_parameter(fields[1].content) if %w[D U].include?(fields[0].content)
    elsif ['Authentication using LDAP', 'Authentication using SQL'].include?(@section)
      output_parameter(fields[0].content)
    end
  end
end
