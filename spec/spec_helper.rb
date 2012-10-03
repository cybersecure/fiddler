PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'fiddler'

RSpec.configure do |config|
   config.treat_symbols_as_metadata_keys_with_true_values = true
   config.run_all_when_everything_filtered = true
   config.filter_run :focus
   config.order = 'random'
end

#load the configuration which should be used to access request tracker
# Fiddler.configure do |config|
# end
# create a file named config.rb here with the block declaration or do it in this file
require 'config'