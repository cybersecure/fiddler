module Fiddler
   module Parsers
      class AttachmentParser < BaseParser
         def self.parse_single(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            attachment_from_response(response)
         end

         def self.parse_content(response)
            response = check_response_code(response,false,false)
            return response.join("\n")
         end

         protected

         def self.check_for_errors(response)
            if response.length == 1
               raise Fiddler::FiddlerError, response.first
            end
            response
         end

         def self.attachment_from_response(response)
            result = {}
            collect_headers = false
            headers = []
            response.each do |line|
               matches = /^(\S*?):\s(.*)/.match(line)
               if(matches)
                  key = matches[1].underscore
                  result[key] = matches[2]

                  if key == "headers"
                     collect_headers = true
                     next
                  elsif key == "content"
                     break
                  end
               end

               spaced_content_matches = /^\s{9}(.*)$/.match(line)
               if spaced_content_matches and collect_headers
                  headers << spaced_content_matches[1]
               end
            end
            result.delete("content")
            headers.unshift(result["headers"])
            result["headers"] = headers
            attachment = Fiddler::Attachment.new(result)
         end
      end
   end
end