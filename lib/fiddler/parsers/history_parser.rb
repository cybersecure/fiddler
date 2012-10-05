module Fiddler
   module Parsers
      class HistoryParser < BaseParser
         def self.parse_single(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            history_from_response(response)
         end

         def self.parse_multiple(response)
            response = check_response_code(response)
            response = check_for_errors(response)
            token_responses = tokenize_response(response)
            histories = Array.new
            token_responses.each do |token_response|
               histories << history_from_response(token_response)
            end
            histories
         end

         protected

         def self.check_for_errors(response)
            if response.length == 1
               raise Fiddler::FiddlerError, response.first
            else
               response.shift
            end
            response
         end

         def self.history_from_response(response)
            result = {}
            content_lines = []
            result["attachment_ids"] = []
            response.each do |line|
               matches = /^(\S*?):\s(.*)/.match(line)
               if(matches)
                  key = matches[1].underscore
                  result[key] = matches[2]
               end

               content_matches = /^\s{9}(.*)$/.match(line)
               if(content_matches)
                  content_lines << content_matches[1]
               end

               attachment_matches = /^\s{13}(.*?):\s(.*)/.match(line)
               if(attachment_matches)
                  result["attachment_ids"] << attachment_matches[1]
               end
            end
            result["attachment_ids"].count.times { content_lines.pop }
            result["content"] += content_lines.join("\n")
            result.delete("attachments")
            history = Fiddler::History.new(result)
         end
      end
   end
end