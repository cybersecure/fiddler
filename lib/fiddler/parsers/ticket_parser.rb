module Fiddler
   module Parsers
      class TicketParser < BaseParser
         def self.parse(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            ticket = hash_from_response(response)
            puts ticket.inspect
            ticket
         end

         protected

         def self.check_for_errors(response)
            message = response.first.strip
            if message =~ /^#/
               raise Fiddler::TicketNotFoundError, message
            end
            response
         end

         def self.hash_from_response(response)
            result = {}
            response.each do |line|
               matches = /^(.*?):\s(.*)/.match(line)
               if(matches)
                  key = matches[1].underscore
                  result[key] = matches[2]
               end
            end
            Fiddler::Ticket.new(result)
         end
      end
   end
end