module Fiddler
  # Based on the Clearance gem configuration - https://github.com/thoughtbot/clearance/blob/master/lib/clearance/configuration.rb
  class Configuration
    attr_accessor :server_url, :username, :password, :use_cookies, :cookie_domain, :ssl_verify

    def initialize
      @use_cookies = false
      @ssl_verify = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end
end