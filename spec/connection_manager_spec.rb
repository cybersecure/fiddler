require 'spec_helper'

describe Fiddler::ConnectionManager do
   before do
      reset_config
   end
   
   describe "without proper config" do
      it "should raise invalid Configuration error for missing configuration" do
         Fiddler.configure do |config|
         end
         expect { Fiddler::ConnectionManager.get("https://www.google.com") }.to raise_error(Fiddler::InvalidConfigurationError)
      end

      it "should raise invalid Configuration error for missing credentials if cookies are not enabled" do
         Fiddler.configure do |config|
            config.server_url = "https://some_server"
         end
         expect { Fiddler::ConnectionManager.get("https://www.google.com") }.to raise_error(Fiddler::InvalidConfigurationError)
      end
   end
end