default.java['jdk_version'] = 7
default.elasticsearch['version'] = '1.4.3'
default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.4.1'
default.elasticsearch['discovery']['type'] = 'ec2'
default.elasticsearch['discovery']['ec2']['groups'] = 'ElasticSearchSG'

default.elasticsearch['cluster']['name'] = 'es.' + node['opsworks']['stack']['name']
default.elasticsearch['node']['name'] = node['opsworks']['instance']['hostname']

# elasticsearch recipe already sets memory to 60%, but we do this explicitly anyways.
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch['allocated_memory'] = allocated_memory

default.opsworks_initial_setup['sysctl']['vm.max_map_count'] = 262144
