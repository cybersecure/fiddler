module Fiddler
   module Formatters
      class BaseFormatter
         def self.format_string(string)
            string.gsub("\r", '').gsub("\n", "\n  ")
         end
      end
   end
end