require 'spec_helper'

describe Fiddler::Parsers::BaseParser do
   before do
      test_config
   end

   use_vcr_cassette "root-request"

   it "should not raise error for valid request" do
      response = Fiddler::ConnectionManager.get("/")
      expect { Fiddler::Parsers::BaseParser.check_response_code(response) }.to_not raise_error
   end

   it "should return an array of lines after checking response" do
      response = Fiddler::ConnectionManager.get("/")
      Fiddler::Parsers::BaseParser.check_response_code(response).should be_a_kind_of(Array)
   end

   it "should strip the response line from return array" do
      response = Fiddler::ConnectionManager.get("/")
      response_array = response.split("\n").reject { |l| l.nil? or l == "" }

      Fiddler::Parsers::BaseParser.check_response_code(response).length.should eql(response_array.length-1)
   end

   it "should return proper number of tokens for length response" do
      response = <<-eos
some response
--
some second response
--
some thrid response
--
the final response
      eos
      response = response.split("\n")
      Fiddler::Parsers::BaseParser.tokenize_response(response).count.should eql(4)
   end
end