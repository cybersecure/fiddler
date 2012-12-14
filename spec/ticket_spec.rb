require 'spec_helper'

describe Fiddler::Ticket do
   before do
      test_config
   end

   describe "Creating tickets" do
      describe "new empty ticket" do
         before do
            @ticket = Fiddler::Ticket.new
         end

         it "should have a valid id" do
            @ticket.id.should eql("ticket/new")
         end

         it "should not be valid" do
            @ticket.should_not be_valid
         end

         it "should return false for save" do
            @ticket.save.should be_false
         end

         it "should populate the errors hash with the errors" do
            @ticket.errors.full_messages.should_not be_empty
         end
      end

      describe "saving tickets" do
         before :each do
            @ticket = Fiddler::Ticket.new
         end

         it "should show the validation errors" do
            @ticket.should_not be_valid
            puts @ticket.errors.full_messages.empty?
         end

         it "should not run the save method" do
            @ticket.save.should be_false
         end

         it "should save the ticket with appropriate attributes set" do
            @ticket.subject = "Trial ticket"
            @ticket.queue = "General"
            @ticket.save.should be_true
            @ticket.id.to_i.should be_kind_of(Integer)
         end

         it "should be able to update the ticket without modifying id, ignoring text" do
            @ticket.subject = "Trial ticket - Update"
            @ticket.queue = "General"
            @ticket.save.should be_true
            @ticket.id.to_i.should be_kind_of(Integer)
            @ticket.subject = "Update Subject after saving the ticket"
            @ticket.save.should be_true
         end

         it "should create a ticket with initial commit" do
            @ticket.subject = "Test ticket with text and requestor"
            @ticket.queue = "General"
            @ticket.requestors = "jais.cheema@cybersecure.com.au"
            @ticket.text = "Creating ticket with requestor and text"
            @ticket.save.should be_true
         end
      end
   end

   describe "updating tickets" do
      it "should update the ticket requestors properly" do
         t = Fiddler::Ticket.get(5234)
         requestors = "#{t.requestors}, rene@cybersecure.com.au"
         t.requestors = requestors
         t.save.should be_true
         t = Fiddler::Ticket.get(5234)
         t.requestors.should eql(requestors)
      end
   end

   describe "managing requestors" do
      it "should return array of requestors" do
         t = Fiddler::Ticket.get(5234)
         requestors = t.requestors
         t.requestor_array.should be_a_kind_of(Array)
         t.requestor_array.should eql(requestors.split(", ").collect { |x| x.strip} )
      end

      it "should add in a proper requestors" do
         t = Fiddler::Ticket.get(5233)
         t.requestor_array = ["jais.cheema@cybersecure.com.au", "rene@cybersecure.com.au"]
         t.save.should be_true
         t = Fiddler::Ticket.get(5233)
         t.requestors.should eql("jais.cheema@cybersecure.com.au, rene@cybersecure.com.au")
      end
   end
   
   describe "Replying to tickets" do

      #use_vcr_cassette "reply-to-tickets"

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

      it "should update the status of the ticket if given in options" do
         ticket = Fiddler::Ticket.get(3300)
         ticket.comment("Something right here", :status => :stalled)
         ticket.status.should eql(:stalled)
      end
   end

   describe "Changing ownership" do

      use_vcr_cassette "change-ownership-steal"

      it "should change the ownership to the current user for steal" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.steal.should_not be_nil
         ticket.owner.should eql(Fiddler.configuration.username)
      end

      use_vcr_cassette "change-ownership-untake"

      it "should change the ownership to the Nobody user for untake" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.untake.should_not be_nil
         ticket.owner.should eql("Nobody")
      end

      use_vcr_cassette "change-ownership-take"

      it "should change the ownership to the current user for take" do
         ticket = Fiddler::Ticket.get(4200)
         ticket.take.should_not be_nil
         ticket.owner.should eql(Fiddler.configuration.username)
      end
   end

   describe "searching tickets" do
      
      use_vcr_cassette "get-tickets"

      it "should find a ticket with given id" do
         ticket = Fiddler::Ticket.get(400)
         ticket.should be_a_kind_of(Fiddler::Ticket)
         ticket.id.should eql(400)
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