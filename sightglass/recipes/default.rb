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

cookbook_file '/usr/local/etc/elasticsearch/scripts/bases_regex.groovy' do
  source 'bases_regex.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end
