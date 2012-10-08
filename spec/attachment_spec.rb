require 'spec_helper'

describe Fiddler::Attachment do
   before do
      test_config
   end

   it "should return proper content" do
      @ticket = Fiddler::Ticket.get(4383)
      attachments = @ticket.histories.last.attachments
      attachments.last.content.should_not be_nil
   end
end