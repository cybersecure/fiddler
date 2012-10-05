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
         @histories = []  
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

      def description
         @attributes.each do |key,value|
            puts "#{key} = #{value}"
         end
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

         # Saves the changes to the ticket object
         #
         # @returns [boolean] save succcessful or not
         def save
         end

         # Find the tickets with the given options
         #
         # @params [Hash] of options
         # @returns [Array<Ticket>] of ticket matching the criteria
         def find(options={})
         end
      end
   end
end