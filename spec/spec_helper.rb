# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
require 'chefspec'
require 'chefspec/berkshelf'

#::Chef::Provider::LWRPBase.build_from_file('prm', 'providers/server.rb', nil)
#::Chef::Provider::LWRPBase.build_from_file('prm', 'providers/resource_link.rb', nil)

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end