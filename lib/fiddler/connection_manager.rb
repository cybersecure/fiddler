module Fiddler
   module ConnectionManager
      class << self
         
         def get(url,options={})
            check_config
         end

         def post(url,data,options={})
            check_config
         end

         protected

         def check_config
            config = Fiddler.configuration
            raise InvalidConfigurationError unless Helper.valid?(config.server_url)
            unless Helper.valid?(config.username) and Helper.valid?(config.password)
               raise InvalidConfigurationError unless config.use_cookies
            end
         end

         def debug
         end

      end # end class method definitions
   end # end ConnectionManager module definition
end # end main module