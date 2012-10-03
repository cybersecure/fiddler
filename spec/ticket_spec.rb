require 'spec_helper'

describe Fiddler::Ticket do
   before do
      test_config
   end
   
   it "should find a ticket with given id" do
      Fiddler::Ticket.get(4357).should_not be_nil
   end

   it "should raise exception for invalid id" do
      expect { Fiddler::Ticket.get(50000) }.to raise_error(Fiddler::TicketNotFoundError)
   end
end