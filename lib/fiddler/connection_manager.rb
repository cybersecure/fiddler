require 'httpclient'
require 'awesome_print'

module Fiddler
   module ConnectionManager

      class Connection
         attr_accessor :client, :logged_in

         def initialize
            @client = HTTPClient.new
            @client.set_cookie_store("cookies.dat")
            @logged_in = false
         end

         def get(path,options)
            login! unless @logged_in
            @client.get(url_for(path),options).content
         end

         def post(path,options)
            login! unless @logged_in
            @client.post(url_for(path),options).content
         end

         def post_content(path,options)
            login! unless @logged_in
            @client.post_content(url_for(path),options)
         end

         private 

         def login!
            unless Fiddler.configuration.use_cookies
               unless @logged_in
                  @client.post(url_for(base_url), :user => Fiddler.configuration.username, :pass => Fiddler.configuration.password )
                  @logged_in = true
               end
            else
               @client.cookie_manager.cookies = []
               cookie = WebAgent::Cookie.new
               cookie.name = Fiddler.configuration.request_tracker_key
               cookie.value = Fiddler.configuration.cookie_value
               cookie.url = URI.parse(Fiddler.configuration.server_url)
               cookie.domain_orig = Fiddler.configuration.cookie_domain
               @client.cookie_manager.add(cookie)
               @logged_in = false
            end
         end

         def base_url
            server_url = Fiddler.configuration.server_url
            if server_url =~ /\/$/
               "#{Fiddler.configuration.server_url}REST/1.0"
            else
               "#{Fiddler.configuration.server_url}/REST/1.0"
            end
         end

         def url_for(path)
            if path =~ /^\//
               "#{base_url}#{path}"
            else
               "#{base_url}/#{path}"
            end
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

         def post_content(url,options={})
            check_config
            debug connection.post_content(url,options)
         end

         protected

         def check_config
            config = Fiddler.configuration
            raise InvalidConfigurationError if config.server_url.blank?
            if config.username.blank? or config.password.blank?
               raise InvalidConfigurationError unless config.use_cookies and config.request_tracker_key and config.cookie_value and config.cookie_domain
            end
         end

         def connection
            self.client_connection ||= Connection.new
         end

         def debug(response)
            if ENV['DEBUG'] or Fiddler.configuration.debug_response
               if defined?(Rails)
                  Rails.logger.debug response
               else
                  ap response
               end
            end
            return response
         end
      end # end class method definitions
   end # end ConnectionManager module definition
end # end main module
