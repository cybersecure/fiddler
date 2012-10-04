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
            options = options_with_login(options)
            @client.get(url,options).content
         end

         def post(url,options)
            url = "#{base_url}#{url}"
            @client.post(url,options_with_login(options)).content
         end

         def options_with_login(options)
            unless Fiddler.configuration.use_cookies
               options.merge({ :user => Fiddler.configuration.username, :pass => Fiddler.configuration.password })
            end
         end
      end

      class << self
         attr_accessor :client_connection

         def get(url,options={})
            check_config
            response = connection.get(url,options)
            debug(response)
            response
         end

         def post(url,options={})
            check_config
            response = connection.post(url,options)
            debug(response)
            response
         end

         protected

         def check_config
            config = Fiddler.configuration
            raise InvalidConfigurationError if config.server_url.blank?
            if config.username.blank? or config.password.blank?
               raise InvalidConfigurationError unless config.use_cookies
            end
         end

         def connection
            self.client_connection ||= Connection.new
         end

         def debug(response)
            puts response.inspect if ENV['DEBUG']
         end
      end # end class method definitions
   end # end ConnectionManager module definition
end # end main module