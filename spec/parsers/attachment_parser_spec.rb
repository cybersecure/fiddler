require 'spec_helper'

describe Fiddler::Parsers::AttachmentParser do
   before do
      test_config
   end

   it "should return Fiddler::Attachment object for parse single call" do
      # http://ticketsdev.cybersecure.local/rt/REST/1.0/ticket/4383/attachments/50992 - png reply
      # http://ticketsdev.cybersecure.local/rt/REST/1.0/ticket/4101/attachments/50313 - text/html reply
      response = Fiddler::ConnectionManager.get("/ticket/4101/history/id/73108")
      Fiddler::Parsers::HistoryParser.parse_single(response).should be_a_kind_of(Fiddler::History)
   end
end