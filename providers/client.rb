#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Provider:: client
#
# Copyright:: Copyright (c) 2014 Criteo.
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
use_inline_resources

include WinrmConfig::ProviderHelper

def load_current_resource
  @current_resource = Chef::Resource::WinrmConfigClient.new(new_resource.name, @run_context)
  @current_resource.properties winrm_config('config/client')['Client']
  Chef::Log.info('Current WinRM client config')
  Chef::Log.info(@current_resource.properties)
end

action :configure do
  if changes? current_resource.properties, new_resource.properties
    converge_by 'configuring WinRM client' do
      winrm_config 'config/client', get_final_config('Client')
    end
    new_resource.updated_by_last_action true
  end
end
