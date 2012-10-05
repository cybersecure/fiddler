require 'rubygems'
require 'spork'
require 'rspec'
require 'vcr'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'fiddler'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { :record => :once }
end

Spork.prefork do
   RSpec.configure do |config|
      config.treat_symbols_as_metadata_keys_with_true_values = true
      config.run_all_when_everything_filtered = true
      config.filter_run :focus

      # Add VCR to all tests
      config.around(:each) do |example|
         options = example.metadata[:vcr] || {}
         if options[:record] == :skip 
            VCR.turned_off(&example)
         else
            name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
            VCR.use_cassette(name, options, &example)
         end
      end
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