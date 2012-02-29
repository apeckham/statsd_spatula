#
# Cookbook Name:: statsd
# Recipe:: default
#
# Copyright 2011, Librato, Inc.
#

include_recipe "nodejs"
include_recipe "git"
include_recipe "npm"

execute "npm install statsd" do
  command "npm install https://github.com/librato/statsd/tarball/master"
  creates "/root/node_modules/statsd-librato"
end

directory "/etc/statsd" do
  action :create
end

template "/etc/statsd/config.js" do
  source "config.js.erb"
  mode 0644
  variables(:port => node[:statsd][:port],
            :graphitePort => node[:statsd][:graphite_port],
            :graphiteHost => node[:statsd][:graphite_host]
            )

  notifies :restart, "service[statsd]"
end

directory "/usr/share/statsd/scripts" do
  action :create
end

template "/usr/share/statsd/scripts/start" do
  source "upstart.start.erb"
  mode 0755
end

cookbook_file "/etc/init/statsd.conf" do
  source "upstart.conf"
  mode 0644
end

user "statsd" do
  comment "statsd"
  system true
  shell "/bin/false"
end

bash "create_log_file" do
  code <<EOH
touch #{node[:statsd][:log_file]} && chown statsd #{node[:statsd][:log_file]}
EOH
  not_if {File.exist?(node[:statsd][:log_file])}
end

service "statsd" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end
