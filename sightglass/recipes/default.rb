# Sets up elasticsearch for sightglass.

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws'
include_recipe 'opsworks_initial_setup::sysctl'
include_recipe 'elasticsearch::proxy'
include_recipe 'elasticsearch::plugins'

# Copy our own groovy scripts.
# This should ideally use recipe variables for paths, owner, and group.
cookbook_file '/usr/local/elasticsearch/config/scripts/bases_regex.groovy' do
  source 'bases_regex.groovy'
  owner 'elasticsearch'
  group 'elasticsearch'
  mode '0644'
  action :create
end
