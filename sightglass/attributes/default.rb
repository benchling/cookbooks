# Versions.
default.java['jdk_version'] = 7
default.elasticsearch['version'] = '1.4.3'
default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.4.1'

# Cluster configuration.
default.elasticsearch['cloud']['aws']['region'] = node['opsworks']['instance']['region']
default.elasticsearch['discovery']['type'] = 'ec2'
default.elasticsearch['discovery']['ec2']['groups'] = 'ElasticSearchSG'
default.elasticsearch['discovery']['zen']['minimum_master_nodes'] = 2

# NGINX proxy.
default.nginx['version'] = '1.6.2'
default.nginx['source']['checksum'] = 'd1b55031ae6e4bce37f8776b94d8b930'
default.elasticsearch['nginx'] = {
    allow_status: true,
    ssl: {}  # Empty ssl dict is workaround for buggy template that tries to access [:ssl][:cert_file]
}

# Names.
default.elasticsearch['cluster']['name'] = 'es.' + node['opsworks']['stack']['name']
default.elasticsearch['node']['name'] = node['opsworks']['instance']['hostname']

# Storage.
default.elasticsearch['path']['data'] = '/vol/es'  # Must match layer settings.

# System settings.
default.opsworks_initial_setup['sysctl']['vm.max_map_count'] = 262144
# elasticsearch recipe already sets memory to 60%, but we do this explicitly anyways.
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch['allocated_memory'] = allocated_memory
