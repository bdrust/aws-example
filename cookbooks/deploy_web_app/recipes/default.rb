service 'iptables' do
  action :stop
end

include_recipe 'nginx'

cookbook_file '/etc/nginx/conf.d/default.conf' do
  source 'default.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

cookbook_file '/usr/share/nginx/html/index.html' do
  source 'index.html'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service 'nginx' do
  action :restart
end
