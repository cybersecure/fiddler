require 'spec_helper'

describe Fiddler::Parsers::AttachmentParser do
   before do
      test_config
   end
   
   it "should return Fiddler::Attachment object for parse single call" do
      response = Fiddler::ConnectionManager.get("/ticket/4299/attachments/47581")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end

   it "should be able to handle the image attachments" do
      response = Fiddler::ConnectionManager.get("/ticket/4300/attachments/47624")
      Fiddler::Parsers::AttachmentParser.parse_single(response).should be_a_kind_of(Fiddler::Attachment)
   end

   it "should give me a properly encoded png image for attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/4300/attachments/47623/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("at2x.png","w") { |f| f.write(content) }
   end

   it "should give me a properly encoded psd file for attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/300/attachments/47628/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("test.psd","w") { |f| f.write(content) }
   end

   it "should give me a properly encoded zip file for attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/4300/attachments/47632/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("test.zip","w") { |f| f.write(content) }
   end

   it "should give me a properly encoded pdf file for attachment" do
      response = Fiddler::ConnectionManager.get("/ticket/4300/attachments/47636/content")
      content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      File.open("test.pdf","w") { |f| f.write(content) }
   end
end