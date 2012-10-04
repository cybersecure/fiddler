require 'spec_helper'

describe Fiddler::Ticket do
   before do
      test_config
   end
   
   it "should find a ticket with given id" do
      Fiddler::Ticket.get(4200).should be_a_kind_of(Fiddler::Ticket)
   end

   it "should raise exception for invalid id" do
      expect { Fiddler::Ticket.get(50000) }.to raise_error(Fiddler::TicketNotFoundError)
   end

   describe "executing all method" do
      it "should return all the user assigned tickets for empty conditions" do
         Fiddler::Ticket.all.should be_a_kind_of(Array)
      end
   end
end