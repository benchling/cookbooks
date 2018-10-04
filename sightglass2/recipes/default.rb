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
    'network.host' => '_site_',  # https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-network.html#network-interface-values
    'cloud.aws.region' => stack['region'],
    'cloud.node.auto_attributes' => true,
    'discovery.type' => 'ec2',
    'discovery.ec2.groups' => node['ec2']['security_groups'][0], # https://github.com/chef/ohai/blob/v8.22.1/lib/ohai/mixin/ec2_metadata.rb#L48
    'discovery.zen.minimum_master_nodes' => 2,
  )
end
elasticsearch_plugin 'cloud-aws' do
  action :install
end
# This creates a sysv sh init script in /etc/init.d.
elasticsearch_service 'elasticsearch'

# Ubuntu 16.04 comes with systemd-sysv installed
# so it creates a systemd unit that runs the sh script created by elasticsearch_service.
# The unit is disabled, so we just need to flip it on.
systemd_unit 'elasticsearch.service' do
  action [:enable, :start]
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
