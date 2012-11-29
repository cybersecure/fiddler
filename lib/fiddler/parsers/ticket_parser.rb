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

         def self.parse_reply_response(response)
            response = check_response_code(response)
            return response.first.match(/^# Message recorded/)
         end

         def self.parse_change_ownership_response(response)
            response = check_response_code(response)
            if response.first =~ /^# Owner changed from (\S+) to (\S+)/
               return $2
            else
               return nil
            end
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
            prev_key = nil
            response.each do |line|
               matches = /^(\S*?):\s(.*)/.match(line)
               if(matches)
                  key = matches[1].underscore
                  prev_key = key
                  result[key] = matches[2]
               else
                  whitespace_matches = /^\s{12}(.*)/.match(line)
                  if whitespace_matches and prev_key
                     values = result[prev_key]
                     values = values.split(",") unless values.is_a?(Array)
                     result[prev_key] = values.concat(whitespace_matches[1].split(",")).collect { |x| x.strip }
                  end
               end
            end
            Fiddler::Ticket.new(result)
         end
      end
   end
end