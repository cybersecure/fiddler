require 'spec_helper'

describe Fiddler::Parsers::TicketParser do
   before do
      test_config
   end

   use_vcr_cassette "get-tickets"
   
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

   it "should give ticket object for parse single method" do
      response = Fiddler::ConnectionManager.get("/ticket/4200")
      Fiddler::Parsers::TicketParser.parse_single(response).should be_a_kind_of(Fiddler::Ticket)
   end

   use_vcr_cassette "search-tickets"

   it "should give array of ticket objects for parse multiple method" do
      response = Fiddler::ConnectionManager.get("/search/ticket?query=Owner='jais.cheema'")
      Fiddler::Parsers::TicketParser.parse_multiple(response).should be_a_kind_of(Array)
   end
end