# Sets up elasticsearch for sightglass.

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws'
include_recipe 'opsworks_initial_setup::sysctl'
include_recipe 'elasticsearch::proxy'
