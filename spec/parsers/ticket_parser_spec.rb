require 'spec_helper'

describe Fiddler::Parsers::TicketParser do
   before do
      test_config
   end
   
   it "should return the response for proper request minus empty line" do
      response = Fiddler::ConnectionManager.get("/ticket/4200")
      response = Fiddler::Parsers::TicketParser.check_response_code(response)
      desired_length = response.length
      Fiddler::Parsers::TicketParser.check_for_errors(response).length.should eql(desired_length)
   end

   it "should raise TicketFetchError for invalid response" do
      response = Fiddler::ConnectionManager.get("/ticket/asdsadasds")
      response = Fiddler::Parsers::TicketParser.check_response_code(response)
      expect { Fiddler::Parsers::TicketParser.check_for_errors(response) }.to raise_error
   end
end