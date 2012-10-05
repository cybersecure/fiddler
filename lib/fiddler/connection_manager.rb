require 'httpclient'

module Fiddler
   module ConnectionManager

      class Connection
         attr_accessor :client, :logged_in

         def initialize
            @client = HTTPClient.new
            @client.set_cookie_store("cookies.dat")
            @logged_in = false
            login!
         end

         def get(path,options)
            @client.get(url_for(path),options).content
         end

         def post(path,options)
            @client.post(url_for(path),options).content
         end

         private 

         def login!
            unless @logged_in
               # in here we can see if the cookie needs to be set or the username and pass needs to be posted across
               post( base_url, :user => Fiddler.configuration.username, :pass => Fiddler.configuration.password )
               @logged_in = true
            end
         end

         def base_url
            "#{Fiddler.configuration.server_url}/REST/1.0/"
         end

         def url_for(path)
            "#{base_url}#{path}"
         end
      end

      class << self
         attr_accessor :client_connection

         def get(url,options={})
            check_config
            debug connection.get(url,options)
         end

         def post(url,options={})
            check_config
            debug connection.post(url,options)
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
            if defined?(Rails)
               Rails.logger.debug response
            elsif ENV['DEBUG']
               puts response.inspect
            end
            return response
         end
      end # end class method definitions
   end # end ConnectionManager module definition
end # end main module