require 'spec_helper'

describe Fiddler::ConnectionManager do
   describe "without proper config" do
      before do
         reset_config
      end

      use_vcr_cassette "root-request"

      it "should raise invalid Configuration error for missing configuration" do
         expect { Fiddler::ConnectionManager.get("/") }.to raise_error(Fiddler::InvalidConfigurationError)
      end

      it "should raise invalid Configuration error for missing credentials if cookies are not enabled" do
         Fiddler.configuration.server_url = "https://some_server"
         expect { Fiddler::ConnectionManager.get("/") }.to raise_error(Fiddler::InvalidConfigurationError)
      end

      it "should raise error for invalid server url" do
         Fiddler.configuration.server_url = "https://some_server"
         Fiddler.configuration.use_cookies = true
         expect { Fiddler::ConnectionManager.get("/") }.to raise_error
      end
   end

   describe "making request" do
      before do
         test_config
      end

      use_vcr_cassette "root-request"

      it "should not return nil response for get request" do
         Fiddler::ConnectionManager.get("/").should_not be_nil
      end

      it "should not return nil response for post request" do
         Fiddler::ConnectionManager.post("/").should_not be_nil
      end
   end
end