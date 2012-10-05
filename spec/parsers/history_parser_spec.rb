require 'spec_helper'

describe Fiddler::Parsers::HistoryParser do
   before do
      test_config
   end

   it "should return Fiddler::History object for parse single call" do
      response = Fiddler::ConnectionManager.get("/ticket/4101/history/id/73108")
      Fiddler::Parsers::HistoryParser.parse_single(response).should be_a_kind_of(Fiddler::History)
   end
end