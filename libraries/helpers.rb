#
# Cookbook:: openssh
# library:: helpers
#
# Copyright:: 2016-2017, Chef Software, Inc.
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
# Attributes are commented out using the default config file values.
# Uncomment the ones you need, or set attributes in a role.
#

module Openssh
  module Helpers
    def openssh_server_options
      options = node['openssh']['server'].sort.reject { |key, _value| key == 'port' || key == 'match' }
      unless node['openssh']['server']['port'].nil?
        port = node['openssh']['server'].select { |key| key == 'port' }.to_a
        options.unshift(*port)
      end
      options
    end

    def sshd_keygen_command
      platform_family?('rhel') ? '/usr/sbin/sshd-keygen' : '/usr/libexec/openssh/sshd-keygen'
    end

    def keygen_platform?
      platform_family?('rhel', 'fedora') &&
        node['platform_version'].to_i >= 7 &&
        !platform?('amazon')
    end

    def sshd_host_keys_missing?
      !node['openssh']['server']['host_key'].all? { |f| ::File.exist?(f) }
    end
  end
end

Chef::Resource.send(:include, ::Openssh::Helpers)
