require 'spec_helper'

describe Fiddler::Parsers::HistoryParser do

   before do
      test_config
   end

   use_vcr_cassette "get-history"

   it "should return Fiddler::History object for parse single call" do
      response = Fiddler::ConnectionManager.get("/ticket/4101/history/id/73108")
      Fiddler::Parsers::HistoryParser.parse_single(response).should be_a_kind_of(Fiddler::History)
   end

   use_vcr_cassette "ticket-histories"

   it "should return Array of Histories for parse multiple call" do
      response = Fiddler::ConnectionManager.get("/ticket/4200/history?format=l")
      histories = Fiddler::Parsers::HistoryParser.parse_multiple(response)
      histories.should be_a_kind_of(Array)
      histories.first.should be_a_kind_of(Fiddler::History)
   end

   use_vcr_cassette "ticket-histories-count"

   it "should return a proper number of histories for a ticket" do
      response = Fiddler::ConnectionManager.get("/ticket/3399/history?format=l")
      histories = Fiddler::Parsers::HistoryParser.parse_multiple(response)
      histories.count.should eql(28)
   end
end