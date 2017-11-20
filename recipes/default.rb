#
# Cookbook Name:: opsworks-route53
# Recipe:: default
#
# Copyright 2017, Tom Alessi
#
# All rights reserved - Do Not Redistribute
#

# This recipe uses the aws-sdk to update the route53 DNS record for the instance
# whenever the recipe runs.

require 'aws-sdk'

# Obtain the stack info from the opsworks data bag
stack = search("aws_opsworks_stack").first

# Instantiate the s3 client
r53 = Aws::Route53::Client.new(
  region: "#{stack['region']}",
  credentials: Aws::InstanceProfileCredentials.new()
)

# Obtain the instance info from the opsworks data bag
instance = search("aws_opsworks_instance", "self:true").first

# Set the options
# UPSERT = create if it does not exist, update if it does
r53_options = {
  :changes => [{
    :action => "UPSERT",
    :resource_record_set => {
      :type => "A",
      :resource_records => [{
        :value => "#{instance['private_ip']}"
      }],
      :name => "#{instance['hostname']}" + '.' + node[:private_settings][:dns][:domain],
      :ttl => node[:private_settings][:dns][:ttl]
    }
  }]
}

# Make the change
r53.change_resource_record_sets(
  :hosted_zone_id => node[:private_settings][:dns][:zone_id],
  :change_batch => r53_options
)
