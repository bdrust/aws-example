require 'serverspec'

require 'spec_helper'

describe command('wget64 -q http://loadbalancer1-341738891.us-east-2.elb.amazonaws.com && (echo OK) || (echo FAIL)') do
  its(:stderr) { should match(/OK/) }
end

describe command('wget64 -q --no-check-certificate https://loadbalancer1-341738891.us-east-2.elb.amazonaws.com  && (echo OK) || (echo FAIL)') do
  its(:stderr) { should match(/OK/) }
end
