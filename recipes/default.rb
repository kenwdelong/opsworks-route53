#
# Cookbook Name:: opsworks-route53
# Recipe:: default
#
# Copyright 2015, Tom Alessi
#
# All rights reserved - Do Not Redistribute
#

# This recipe uses the aws-sdk to update the route53 DNS record for the instance
# whenever the recipe runs.

require 'aws-sdk'

r53 = AWS::Route53.new

# Set the options
# UPSERT = create if it does not exist, update if it does
r53_options = {
  :changes => [{
    :action => "UPSERT",
    :resource_record_set => {
      :type => "A",
      :resource_records => [{ 
        :value => node[:opsworks][:instance][:private_ip]
      }],
      :name => node[:opsworks][:instance][:hostname] + '.' + node[:private_settings][:dns][:domain],
      :ttl => node[:private_settings][:dns][:ttl]
    }
  }]
}

# Make the change
r53.client.change_resource_record_sets(
	:hosted_zone_id => node[:private_settings][:dns][:zone_id],
	:change_batch => r53_options
)
