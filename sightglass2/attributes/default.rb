default.java['jdk_version'] = '8'

# NGINX proxy
default.elasticsearch['nginx']['allow_status'] = true
default.elasticsearch['nginx']['client_max_body_size'] = '128M'
# Empty ssl dict is workaround for buggy template that tries to access [:ssl][:cert_file]
default.elasticsearch['nginx']['ssl'] = {}

# Monitoring plugins
default.elasticsearch['plugins']['lukas-vlcek/bigdesk'] = {}
default.elasticsearch['plugins']['royrusso/elasticsearch-HQ'] = {}
default.elasticsearch['plugins']['lmenezes/elasticsearch-kopf']['version'] = 'v1.6.1'

# Attachment plugin
#default.elasticsearch['plugins']['elasticsearch/elasticsearch-mapper-attachments']['version'] = '2.7.1'
