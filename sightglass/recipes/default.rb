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