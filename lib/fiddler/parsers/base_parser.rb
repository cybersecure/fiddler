module Fiddler
   module Parsers
      class BaseParser
         def self.successful?(response)
            lines = response.split("\n")
            lines.first =~ /200/ ? true : false
         end

         def self.message(response)
            # strip out the message from the first line and return it
         end
      end
   end
end