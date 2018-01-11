require 'chef/provisioning'
require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-2'

machine 'web_server_1' do
  action :destroy
end

load_balancer 'loadbalancer1' do
  action :destroy
 end