require 'chef/provisioning'
require 'chef/provisioning/aws_driver'
require 'aws-sdk'

with_driver 'aws::us-east-2'

machine 'web_server_1' do
  action :converge
  run_list ['deploy_web_app']
  chef_config "log_level :info\n"
  retries 5
  retry_delay 60
  machine_options({
                    bootstrap_options: {
                      subnet_id: 'subnet-9b5384f3',
                      security_group_ids: 'sg-e473698c',
                      key_name: 'drusty',
                      key_path: 'c:\users\brian\.ssh\drusty.pem',
                      instance_type: 't2.micro',
                      associate_public_ip_address: true,
                      image_id: 'ami-6a9cbe0f',         
                    },
                    convergence_options: {
                      chef_client_timeout: 3600,
                      ssl_verify_mode: :verify_none
                    },                  
                    ssh_username: 'root'
                  })
end

#iam = Aws::IAM.new
iam = Aws::IAM::Client.new(region: 'us-east')
resp = iam.get_server_certificate({server_certificate_name: "self_signed_cert"})
cert = resp.server_certificate.server_certificate_metadata.arn

load_balancer 'loadbalancer1' do
  name 'loadbalancer1'
  machines ['web_server_1']
  load_balancer_options(
  {
    subnets: [ 'subnet-9b5384f3' ],
    security_groups: [ 'sg-9dda3ef6' ],
    listeners: [ {
      instance_port: 80,
      protocol: 'HTTP',
      instance_protocol: 'HTTP',
      port: 80
    },
    {
      instance_port: 80,
      protocol: 'HTTPS',
      instance_protocol: 'HTTP',
      port: 443,
      ssl_certificate_id: cert
    } ],
    health_check: {
      healthy_threshold:    2,
      unhealthy_threshold:  4,
      interval:             12,
      timeout:              5,
      target:               "HTTP:80/"
    }
  })
end