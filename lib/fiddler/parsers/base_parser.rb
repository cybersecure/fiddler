module Fiddler
   module Parsers
      class BaseParser
         
         SUCCESS_CODES = (200..299).to_a
         ERROR_CODES = (400..499).to_a
         
         def self.check_response_code(response, reject_blank_lines=true)
            response = safe_encode(response)
            lines = response.split("\n")
            lines = lines.delete_if { |l| l.nil? or l == "" } if reject_blank_lines
            if lines.count == 0
               raise RequestError, "Empty Response"
            else
               status_line = lines.shift
               version, status_code, status_text = status_line.split(/\s+/,2)
               unless SUCCESS_CODES.include?(status_code.to_i)
                  raise RequestError, status_text
               end
               lines.shift unless reject_blank_lines
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

         protected

         def self.safe_encode(response)
            require 'iconv' unless String.method_defined?(:encode)
            if String.method_defined?(:encode)
               response.encode!('UTF-8', 'UTF-8', :invalid => :replace)
            else
               begin
                  Iconv.iconv("UTF-8//IGNORE", "UTF-8", response).join("")
               rescue Exception => e
                  raise IllegalCharacterError, "Attachment contains illegal characters"
               end 
            end
            response
         end
      end
   end
end