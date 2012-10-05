require 'spec_helper'

describe Fiddler::Parsers::AttachmentParser do
   before do
      test_config
   end
   
   it "should return Fiddler::Attachment object for parse single call" do
      response = Fiddler::ConnectionManager.get("/ticket/4101/attachments/50313")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end

   it "should be able to handle the image attachments" do
      response = Fiddler::ConnectionManager.get("/ticket/4383/attachments/50992")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end
end