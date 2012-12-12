require 'active_attr'
module Fiddler
   class Ticket
      include ActiveAttr::Model

      attribute :id, :default => 'ticket/new'
      attribute :queue
      attribute :owner
      attribute :creator
      attribute :subject
      attribute :status
      attribute :priority
      attribute :initial_priority
      attribute :final_priority
      attribute :requestors
      attribute :cc
      attribute :admin_cc
      attribute :created
      attribute :starts
      attribute :started
      attribute :due
      attribute :resolved
      attribute :told
      attribute :last_updated
      attribute :time_estimated
      attribute :time_worked
      attribute :time_left
      attribute :text

      attribute :new_record, :default => true

      validates_presence_of :id, :queue, :subject

      def histories
         if @histories == nil
            url = "ticket/#{id}/history"
            response = Fiddler::ConnectionManager.get(url, {:format => "l"})
            @histories = Fiddler::Parsers::HistoryParser.parse_multiple(response)
         end
         @histories
      end

      # Add a comment to a ticket
      # Example:
      #   tix = Ticket.get(1000)
      #   tix.comment("This is a comment", :time_worked => 45, :cc => 'someone@example.com')
      #
      #   Attachments
      #   tix.comment("This is a comment", :attachments => "/tmp/filename.txt")
      #
      #   Attachment as a file descriptor
      #   tix.correspond("This is a comment", :attachments => File.new("/tmp/filename.txt"))
      #
      #   Attachment as a ActionDispatch::Http::UploadedFile instance
      #   tix.comment("This is a comment", :attachments => [params[:attachment_1], params[:attachment_2]])
      #
      def comment(comment, opt = {})
         reply('Comment', comment, opt)
      end

      def correspond(comment, opt = {})
         reply('Correspond', comment, opt)
      end

      def steal
         change_ownership "Steal"
      end

      def take
         change_ownership "Steal"
      end

      def untake
         change_ownership "Untake"
      end

      def save
         id == "ticket/new" ? create : update
      end

      protected

      def reply(method, comment, opt)
         # make sure the options are only the valid ones.
         valid_options = [:cc, :bcc, :time_worked, :attachments, :status]
         opt.delete_if { |key,value| !valid_options.include?(key) }

         payload = { :text => comment, :action => method}.merge(opt)
         payload.delete(:attachments)

         attachments = Fiddler::AttachmentCollection.fill(opt[:attachments])
         payload.merge!(:attachment => attachments.map(&:basename).join(",")) unless attachments.empty?

         response = Fiddler::ConnectionManager.post_content("ticket/#{id}/comment", { :content => payload.to_content_format }.merge(attachments.to_payload) )

         result = Fiddler::Parsers::TicketParser.parse_reply_response(response)

         # update the ticket parameters if the action was successful
         if result and opt.has_key?(:status)
            self.status = opt[:status]
            result
         else
            result
         end
      end

      def change_ownership(method)
         payload = { "Action" => method }
         response = Fiddler::ConnectionManager.post("ticket/#{id}/take", :content => payload.to_content_format)
         new_owner = Fiddler::Parsers::TicketParser.parse_change_ownership_response(response)
         if new_owner
            self.owner = new_owner
            return self
         else
            return nil
         end
      end

      def create
         response = Fiddler::ConnectionManager.post("ticket/new", @attributes.to_content_format)
         puts response.inspect
         #return Fiddler::Parsers::TicketParser.parse_single(response, :create)
      end

      def update
         payload = @attributes.clone
         payload.delete("text")
         payload.delete("id") 
         response = Fiddler::ConnectionManager.post("ticket/#{id}/edit", payload.to_content_format)
         puts response.inspect
         #return Fiddler::Parsers::TicketParser.parse_single(response, :update)
      end

      # Class methods
      class << self
         # Gets the ticket with given id
         #
         # @params [int] id for the ticket
         # @returns [Ticket] returns ticket the ticket object
         def get(id)
            url = "ticket/#{id}"
            response = Fiddler::ConnectionManager.get(url)
            ticket = Fiddler::Parsers::TicketParser.parse_single(response)
            ticket
         end

         # Search the tickets with the given conditions
         #
         # @params [Hash] of conditions
         # @returns [Array<Ticket>] of the tickets matching the criteria
         def all(conditions={})
            tickets = []
            url = "search/ticket"
            request_hash = Fiddler::Formatters::SearchRequestFormatter.format(conditions)
            unless request_hash.empty?
               response = Fiddler::ConnectionManager.get(url,request_hash)
               tickets = Fiddler::Parsers::TicketParser.parse_multiple(response)
            end
            tickets
         end

         # Creates a new ticket with the given options, it will not save the ticket
         #
         # @params [Hash] of the options to be added to the new ticket
         # @returns [Ticket] returns new ticket object
         def create(options)
         end
      end
   end
end