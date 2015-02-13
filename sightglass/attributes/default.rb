default.java['jdk_version'] = 7
default.elasticsearch['version'] = '1.4.3'
default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.4.1'
default.elasticsearch['discovery']['type'] = 'ec2'
default.elasticsearch['discovery']['ec2']['groups'] = 'ElasticSearchSG'

default.elasticsearch['cluster']['name'] = 'es.' + node['opsworks']['stack']['name']
default.elasticsearch['node']['name'] = node['opsworks']['instance']['hostname']
