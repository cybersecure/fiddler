module Fiddler
   class FiddlerError < StandardError; end
   class TicketNotFoundError < StandardError; end
   class InvalidConfigurationError < StandardError; end
   class TicketAccessDeniedError < StandardError; end
   class RequestError < StandardError; end
end