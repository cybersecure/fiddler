module Fiddler
   module Parsers
      class TicketParser < BaseParser
         def self.parse(response)
            success = self.successful?(response)
            puts success ? "Successful" : "Failed"
         end
      end
   end
end