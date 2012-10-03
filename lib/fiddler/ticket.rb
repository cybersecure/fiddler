module Fiddler
   class Ticket
      attr_accessor :id, :subject, :status, :queue, :owner, :creator, :histories, :content, :last_updated

      # Initializes a new instance of ticket object
      #
      # @params [Hash] of the initial options
      def initialize(options={})
         options = { :queue => "General", :owner => "Nobody", :status => "new"}.merge options
         options.each do |key,value|
            send "#{key}=", value
         end
         @id = "ticket/new"
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