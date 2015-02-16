# Sets up elasticsearch for sightglass.

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws'
# include_recipe 'elasticsearch::ebs'
# include_recipe 'elasticsearch::data'
include_recipe 'opsworks_initial_setup::sysctl'

# elasticsearch::monit recipe doesn't seem to play well with opsworks monit, just need template
template File.join(node[:monit][:conf_dir], "elasticsearch.monitrc") do
    source 'elasticsearch.monitrc.conf.erb'
    mode 0600
    owner 'root'
    group 'root'
end

service 'monit' do
    action :reload
end
