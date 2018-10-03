# Sets up elasticsearch for sightglass

include_recipe 'java'
#include_recipe 'elasticsearch'
#include_recipe 'elasticsearch::aws'
#include_recipe 'elasticsearch::proxy'
#include_recipe 'elasticsearch::plugins'

package %w(htop tree)
package 'command-not-found' do
  action :purge
end

sysctl_param 'vm.max_map_count' do
  value 262144
end

# https://docs.aws.amazon.com/opsworks/latest/userguide/data-bag-json-stack.html
stack = search(:aws_opsworks_stack).first

# We're on the 2.x.x branch of the cookbook: https://github.com/elastic/cookbook-elasticsearch/tree/2.x.x
elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  version '2.3.5'
end
elasticsearch_configure 'elasticsearch' do
  path_data package: '/vol/es'  # Must match opsworks layer settings
  allocated_memory "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
  configuration(
    'cluster.name' => 'es.' + stack['name'],
    'node.name' => node['hostname'],  # https://docs.chef.io/attributes.html#automatic-ohai
	'discovery.type' => 'ec2',
	'discovery.ec2.groups' => 'ElasticSearchSG',
	'discovery.zen.minimum_master_nodes' => 2,
  )
end
elasticsearch_service 'elasticsearch'
elasticsearch_plugin 'cloud-aws' do
  action :install
end

# Copy our own groovy scripts.
cookbook_file '/etc/elasticsearch/scripts/source_regex.groovy' do
  source 'source_regex.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

cookbook_file '/etc/elasticsearch/scripts/modified_time.groovy' do
  source 'modified_time.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

cookbook_file '/etc/elasticsearch/scripts/sort_value.groovy' do
  source 'sort_value.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end

cookbook_file '/etc/sudoers.d/20-foxpass' do
  source '20-foxpass'
  owner 'root'
  group 'root'
  mode '0440'
  action :create
end

=begin
foxpass_secrets = data_bag_item("sightglass", "foxpass")

bash 'install_foxpass' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
      wget https://raw.githubusercontent.com/foxpass/foxpass-setup/master/linux/ubuntu/16.04/foxpass_setup.py
      python3 foxpass_setup.py --base-dn dc=benchling,dc=com --bind-user linux --bind-pw #{foxpass_secrets["bind_pw"]} \
          --api-key "#{foxpass_secrets["api_key"]}"
      rm foxpass_setup.py
      mkdir -p /opt/chef-foxpass/
      touch /opt/chef-foxpass/done
      EOH
  not_if { ::File.exists?('/opt/chef-foxpass/done') }
end
=end
