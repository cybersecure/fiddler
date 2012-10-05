module Fiddler
   module Parsers
      class BaseParser
         
         SUCCESS_CODES = (200..299).to_a
         ERROR_CODES = (400..499).to_a
         
         def self.check_response_code(response)
            lines = response.split("\n").reject { |l| l.nil? or l == "" }
            if lines.count == 0
               raise RequestError, "Empty Response"
            else
               status_line = lines.shift
               version, status_code, status_text = status_line.split(/\s+/,2)
               unless SUCCESS_CODES.include?(status_code.to_i)
                  raise RequestError, status_text
               end
               lines
            end
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