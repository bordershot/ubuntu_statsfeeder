#
# Cookbook Name:: ubuntu_statsfeeder
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'default-jre'

# Download the statsfeeder-[version].zip archive, extract the archive, strip the
# top level dir and place results into /usr/local/statsfeeder/versions/[version]
# and symlink /usr/local/statsfeeder/versions/current to /usr/local/statsfeeder/versions/1.0

archive 'statsfeeder' do
  url "http://download3.vmware.com/software/vmw-tools/statsfeeder/StatsFeeder-#{node['statsfeeder']['version']}.zip"
  version "#{node['statsfeeder']['version']}"
  extract_action 'unzip'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/StatsFeeder.sh" do
  source 'StatsFeeder.sh'
end

cookbook_file '/etc/init.d/statsfeeder' do
  source 'statsfeeder'
  mode '0755'
  owner 'root'
  group 'root'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/config/graphiteConfig.xml" do
  source 'graphiteConfig.xml'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/config/rules.xml" do
  source 'rules.xml'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/log4j.properties" do
  source 'log4j.properties'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/lib/statsfeeder-GraphiteReceiver-1.0-IPM-4.0.jar" do
  source 'statsfeeder-GraphiteReceiver-1.0-IPM-4.0.jar'
end

cookbook_file "#{node['statsfeeder']['install_dir']}/config/config.xml" do
  source 'statsfeeder-GraphiteReceiver-1.0-IPM-4.0.jar'
end

template '/etc/default/statsfeeder' do
  source 'statsfeeder.erb'
  mode '0600'
end

bash 'reload systemctl' do
  code <<-EOH
    /bin/systemctl daemon-reload
    EOH
end

service 'statsfeeder' do
  action [:enable, :start]
end
