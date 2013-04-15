#
# Cookbook Name:: pzh-server
# Recipe:: default
#
# Copyright 2012, webinos
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packages = %w(openjdk-7-jdk libopenobex1-dev libobexftp0-dev bluetooth
  libpam0g-dev libcairo2-dev libjpeg8-dev libgif-dev
  libavahi-compat-libdnssd-dev libgnome-keyring-dev 'g++' ant libssl-dev)
packages.each do |package_name|
  package(package_name) do
    action :install
  end
end

directory "/opt/Webinos-Platform" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

git "Checkout Code" do
  repository "git://github.com/webinos/Webinos-Platform.git"
  reference "master" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  action :sync
  destination "/opt/Webinos-Platform"
  retries 3
  user "vagrant"
  group "vagrant"
end

execute "npm update" do
  user "root"
  command "npm update -g npm"
end

execute "Install grunt" do
  user "root"
  command "npm install -g grunt-cli"
end

execute "Install webinos" do
  user "vagrant"
  group "vagrant"
  cwd "/opt/Webinos-Platform"
  command "npm install"
  retries 3
  environment 'HOME' => '/home/vagrant'
end

execute "Install forever" do
  command "npm install -g forever"
end

execute "Run PZH" do
  user "root"
  group "root"
  cwd "/opt/Webinos-Platform"
  command 'node ./webinos_pzh.js --host="localhost" --name="localhost"' 
# disable this in future. atm is fix for CommandTimeout Error fix
  timeout 99999999
end
