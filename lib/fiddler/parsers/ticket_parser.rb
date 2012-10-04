module Fiddler
   module Parsers
      class TicketParser < BaseParser
         def self.parse_single(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            ticket_from_response(response)
         end

         def self.parse_multiple(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            ticket_token_responses = tokenize_response(response)
            tickets = Array.new
            ticket_token_responses.each do |token_response|
               tickets << ticket_from_response(token_response)
            end
            tickets
         end

         protected

         def self.check_for_errors(response)
            message = response.first.strip
            if message =~ /^#/
               raise Fiddler::TicketNotFoundError, message
            end
            response
         end

         def self.ticket_from_response(response)
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

         def self.tokenize_response(response)
            tokens = Array.new
            current = Array.new
            response.each do |item|
               if(item == "--")
                  tokens << current
                  current = Array.new
                  next
               end
               current << item
            end
            tokens
         end
      end
   end
end