# Sets up elasticsearch for sightglass.

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws'
include_recipe 'opsworks_initial_setup::sysctl'
include_recipe 'elasticsearch::proxy'
include_recipe 'elasticsearch::plugins'

# Copy our own groovy scripts.
# This should ideally use recipe variables for paths, owner, and group.
directory '/usr/local/etc/elasticsearch/scripts' do
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0755'
  action :create
  recursive true
end

cookbook_file '/usr/local/etc/elasticsearch/scripts/source_regex.groovy' do
  source 'source_regex.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

cookbook_file '/usr/local/etc/elasticsearch/scripts/modified_time.groovy' do
  source 'modified_time.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

cookbook_file '/usr/local/etc/elasticsearch/scripts/sort_value.groovy' do
  source 'sort_value.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

# cookbook_file '/etc/sudoers.d/20-foxpass' do
#   source '20-foxpass'
#   owner 'root'
#   group 'root'
#   mode '0440'
#   action :create
# end

# foxpass_secrets = data_bag_item("sightglass", "foxpass")

# bash 'install_foxpass' do
#   user 'root'
#   cwd '/tmp'
#   code <<-EOH
#       wget https://raw.githubusercontent.com/foxpass/foxpass-setup/master/linux/ubuntu/14.04/foxpass_setup.py
#       python foxpass_setup.py --base-dn dc=benchling,dc=com --bind-user linux --bind-pw #{foxpass_secrets["bind_pw"]} \
#           --api-key "#{foxpass_secrets["api_key"]}"
#       rm foxpass_setup.py
#       mkdir -p /opt/chef-foxpass/
#       touch /opt/chef-foxpass/done
#       EOH
#   not_if { ::File.exists?('/opt/chef-foxpass/done') }
# end
