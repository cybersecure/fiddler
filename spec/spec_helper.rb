require 'rubygems'
require 'spork'
require 'rspec'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'fiddler'

Spork.prefork do
   RSpec.configure do |config|
      config.treat_symbols_as_metadata_keys_with_true_values = true
      config.run_all_when_everything_filtered = true
      config.filter_run :focus
   end
end

Spork.each_run do
end

# create a file named config.rb here with the two methods
# def test_config
#    Fiddler.configure do |config|
#       config.server_url = "some_url"
#       config.username = "username"
#       config.password = "password"
#    end
# end
# def reset_config
#    Fiddler.configure do |config|
#       config.server_url = nil
#       config.username = nil
#       config.password = nil
#       config.use_cookies = false
#       config.ssl_verify = true
#    end
# end

require 'config'