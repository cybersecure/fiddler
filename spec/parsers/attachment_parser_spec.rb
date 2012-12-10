require 'spec_helper'

describe Fiddler::Parsers::AttachmentParser do
   before do
      test_config
   end
   
   it "should return Fiddler::Attachment object for parse single call" do
      response = Fiddler::ConnectionManager.get("/ticket/3399/attachments/47494")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end

   it "should be able to handle the image attachments" do
      response = Fiddler::ConnectionManager.get("/ticket/3399/attachments/57344")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end

   it "should give me a properly encoded png image for attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/3399/attachments/57336/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("12.jpg","w") { |f| f.write(content) }
   end

   it "should give me a properly encoded file for any kind of attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/3399/attachments/57348/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("test.graffle","w") { |f| f.write(content) }
   end
end