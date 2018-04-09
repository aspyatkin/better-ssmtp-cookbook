id = 'better-ssmtp'

instance = ::ChefCookbook::Instance::Helper.new(node)
secret = ::ChefCookbook::Secret::Helper.new(node)

package 'ssmtp' do
  action :install
end

case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package 'mailx'
when 'debian'
  package 'mailutils'
end

template '/etc/ssmtp/ssmtp.conf' do
  source 'ssmtp.conf.erb'
  owner instance.root
  group node['root_group']
  variables(
    sender_email: node[id]['sender_email'],
    smtp_host: secret.get("#{id}:smtp:host"),
    smtp_port: secret.get("#{id}:smtp:port"),
    smtp_username: secret.get("#{id}:smtp:username"),
    smtp_password: secret.get("#{id}:smtp:password"),
    smtp_enable_starttls: secret.get("#{id}:smtp:enable_starttls"),
    smtp_enable_ssl: secret.get("#{id}:smtp:enable_ssl"),
    from_line_override: node[id]['from_line_override']
  )
  sensitive true
  action :create
end

template '/etc/ssmtp/revaliases' do
  source 'revaliases.erb'
  owner instance.root
  group node['root_group']
  variables(
    sender_email: node[id]['sender_email'],
    smtp_host: secret.get("#{id}:smtp:host"),
    smtp_port: secret.get("#{id}:smtp:port")
  )
  action :create
end
