#
# Cookbook Name:: sightglass
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
#

include_recipe 'java'
include_recipe 'elasticsearch'
# include_recipe 'elasticsearch::monit'
include_recipe 'elasticsearch::aws'
# include_recipe 'elasticsearch::data'
# include_recipe 'elasticsearch::ebs'

# Half of memory towards ES heap.
env 'ES_HEAP_SIZE' do
    value (node.memory.total.to_i / 2).to_s
end
