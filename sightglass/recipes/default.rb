#
# Cookbook Name:: sightglass
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
#

include_recipe 'java'
include_recipe 'elasticsearch::default'
# include_recipe 'elasticsearch::monit'
include_recipe 'elasticsearch::aws'
# include_recipe 'elasticsearch::data'
# include_recipe 'elasticsearch::ebs'
