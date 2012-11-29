module Fiddler
   class Ticket

      DefaultAttributes = %w(queue owner creator subject status priority initial_priority final_priority requestors cc admin_cc created starts started due resolved told last_updated time_estimated time_worked time_left text).inject({}){|memo, k| memo[k] = nil; memo}
      RequiredAttributes = %w(queue subject)

      attr_reader :histories, :saved
      
      # Initializes a new instance of ticket object
      #
      # @params [Hash] of the initial options
      def initialize(attributes={})
         if attributes
            @attributes = DefaultAttributes.merge(attributes)
         else
            @attributes = DefaultAttributes
         end
         @attributes.update(:id => 'ticket/new')
         @saved = false
         @histories = nil
         @new_record = true
         add_methods!
      end

      def add_methods!
         @attributes.each do |key, value|
            (class << self; self; end).send :define_method, key do
               return @attributes[key]
            end
            (class << self; self; end).send :define_method, "#{key}=" do |new_val|
               @attributes[key] = new_val
            end
         end
      end

      def to_s
         @attributes.each do |key,value|
            if value.is_a?(Array) or value.is_a?(Hash)
               puts "#{key} : #{value.inspect}"
            else
               puts "#{key} : #{value}"
            end
         end
      end

      def histories
         if @histories == nil
            url = "ticket/#{id}/history"
            response = Fiddler::ConnectionManager.get(url, {:format => "l"})
            @histories = Fiddler::Parsers::HistoryParser.parse_multiple(response)
         end
         @histories
      end

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
         valid_options = [:cc, :bcc, :time_worked, :attachment, :status]
         opt.delete_if { |key,value| !valid_options.include?(key) }

         payload = { :text => comment, :action => method}.merge(opt)
         response = Fiddler::ConnectionManager.post("ticket/#{id}/comment", :content => payload.to_content_format)
         return Fiddler::Parsers::TicketParser.parse_reply_response(response)
      end

      def change_ownership(method)
         payload = { "Action" => method }
         response = Fiddler::ConnectionManager.post("ticket/#{id}/take", payload.to_content_format)
         puts response.inspect
         #return Fiddler::Parsers::TicketParser.parse_single(response, method)
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
            ticket.id = id
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