default.java['jdk_version'] = 7
default.elasticsearch['version'] = '1.4.3'
default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.4.1'
default.elasticsearch['cloud']['aws']['region'] = node['opsworks']['instance']['region']
default.elasticsearch['discovery']['type'] = 'ec2'
default.elasticsearch['discovery']['ec2']['groups'] = 'ElasticSearchSG'
default.elasticsearch['discovery']['zen']['minimum_master_nodes'] = 2

# Names.
default.elasticsearch['cluster']['name'] = 'es.' + node['opsworks']['stack']['name']
default.elasticsearch['node']['name'] = node['opsworks']['instance']['hostname']

# Storage.
default.elasticsearch['data']['devices']['/dev/sdf'] = {
    file_system: 'ext4',
    mount_options: 'rw,user',
    mount_path: '/usr/local/var/data/elasticsearch/disk1',
    format_command: 'mkfs.ext4',
    fs_check_command: 'dumpe2fs',
    ebs: {
        size: 32,  # GB
        delete_on_termination: true,
        type: 'gp2'
    }
}

default.opsworks_initial_setup['sysctl']['vm.max_map_count'] = 262144
# elasticsearch recipe already sets memory to 60%, but we do this explicitly anyways.
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch['allocated_memory'] = allocated_memory
