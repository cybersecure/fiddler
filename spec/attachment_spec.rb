require 'spec_helper'

describe Fiddler::Attachment do
   before do
      test_config
   end

   it "should return proper content" do
      @ticket = Fiddler::Ticket.get(4300)
      @ticket.histories.each do |history|
         history.attachments.each do |attachment|
            attachment.content.should_not be_nil
         end
      end
   end

   it "should have proper response for text attachment" do
      @attachment = Fiddler::Attachment.get(47622,4300)
      @attachment.content.should_not be_nil
   end

   it "should have proper response for image attachment" do
      @attachment = Fiddler::Attachment.get(47623,4300)
      @attachment.content.should_not be_nil
   end
end