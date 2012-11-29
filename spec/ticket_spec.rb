require 'spec_helper'

describe Fiddler::Ticket do
   before do
      test_config
   end
   
   describe "Replying to tickets" do

      use_vcr_cassette "reply-to-tickets"

      it "should comment on a ticket" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.comment("nice comment").should be_true
      end

      it "should purge any useless options given with comment" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.comment("nice comment", :useless => true).should be_true
      end

      it "should be able to correspond" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.correspond("nice email").should be_true
      end

      it "should be able to comment with options" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.correspond("nice email", :cc => "jaischeema@gmail.com", :time_worked => 10, :status => :open).should be_true
      end
   end

   describe "Changing ownership" do

      use_vcr_cassette "change-ownership-steal"

      it "should change the ownership to the current user for steal" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.steal
         ticket.owner.should eql(Fiddler.configuration.username)
      end

      use_vcr_cassette "change-ownership-untake"

      it "should change the ownership to the Nobody user for untake" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.untake
         ticket.owner.should eql("Nobody")
      end

      use_vcr_cassette "change-ownership-take"

      it "should change the ownership to the current user for take" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.take
         ticket.owner.should eql(Fiddler.configuration.username)
      end
   end

   describe "searching tickets" do
      
      use_vcr_cassette "get-tickets"

      it "should find a ticket with given id" do
         ticket = Fiddler::Ticket.get(400)
         ticket.should be_a_kind_of(Fiddler::Ticket)
      end

      it "should raise exception for invalid id" do
         expect { Fiddler::Ticket.get(50000) }.to raise_error(Fiddler::TicketNotFoundError)
      end

      it "should return empty array for empty conditions" do
         Fiddler::Ticket.all.should be_a_kind_of(Array)
         Fiddler::Ticket.all.length.should eql(0)
      end

      it "should return all tickets owned by the user for owner query" do
         tickets = Fiddler::Ticket.all(:owner => "jais.cheema")
         tickets.each do |ticket|
            ticket.owner.should eql("jais.cheema")
         end
      end

      it "should be able to handle mutliple values for a condition" do
         tickets = Fiddler::Ticket.all( :status => [:open, :resolved ])
         tickets.each do |ticket|
            ticket.status.should match(/open|resolved/)
         end 
      end
   end

   describe "histories" do
      before do
         @ticket = Fiddler::Ticket.get(4200)
      end

      use_vcr_cassette "ticket-histories"

      it "should return an array of history items" do
         @ticket.histories.should be_a_kind_of(Array)
         @ticket.histories.first.should be_a_kind_of(Fiddler::History)
      end
   end
end