require 'httpclient'

module Fiddler
   module ConnectionManager

      class Connection
         attr_accessor :client
         def initialize
            @client = HTTPClient.new
            @client.set_cookie_store("cookies.dat")
         end

         def base_url
            "#{Fiddler.configuration.server_url}/REST/1.0/"
         end

         def get(url,options)
            url = "#{base_url}#{url}"
            @client.get(url,options_with_login(options)).content
         end

         def post
         end

         def options_with_login(options)
            unless Fiddler.configuration.use_cookies
               options.merge({ :user => Fiddler.configuration.username, :pass => Fiddler.configuration.password })
            end
         end
      end

      class << self
         attr_accessor :client_connection

         def connection
            self.client_connection ||= Connection.new
         end

         def get(url,options={})
            check_config
            connection.get(url,options)
         end

         def post(url,data,options={})
            check_config
            connection.post(url,options)
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