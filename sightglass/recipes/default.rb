# Sets up elasticsearch for sightglass.

include_recipe 'java'
include_recipe 'elasticsearch'
# include_recipe 'elasticsearch::monit'
include_recipe 'elasticsearch::aws'
# include_recipe 'elasticsearch::ebs'
# include_recipe 'elasticsearch::data'
include_recipe 'opsworks_initial_setup::sysctl'
