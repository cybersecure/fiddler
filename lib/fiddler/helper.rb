module Fiddler
   module Helper
      class << self
         def valid?(value)
            ( value.nil? or value == "" ) ? false : true
         end
      end
   end
end