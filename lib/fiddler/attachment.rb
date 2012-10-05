module Fiddler
   class Attachment
      DefaultAttributes = %w(id subject creator created transaction parent message_id filename content_type content_encoding).inject({}){|memo, k| memo[k] = nil; memo}
      
      attr_reader :ticket_id, :content
      
      # Initializes a new instance of history object
      #
      # @params [Hash] of the initial options
      def initialize(attributes={})
         if attributes
            @attributes = DefaultAttributes.merge(attributes)
         else
            @attributes = DefaultAttributes
         end
         @ticket_id = nil
         @content = nil
         add_methods!
      end

      def add_methods!
         @attributes.each do |key, value|
            (class << self; self; end).send :define_method, key do
               return @attributes[key]
            end
            (class << self; self; end).send :define_method, "#{key}=" do |new_val|
               @attributes[key] = new_val
            end
         end
      end

      def content
         if @content == nil
            # get the content from the url and put it in
            @content = ""
         end
         @content
      end

      def self.get(ticket_id, id)
         url = "/tickt/#{ticket_id}/attachments/#{id}"
         response = Fiddler::ConnectionManager.get(url)
         attachment = Fiddler::Parsers::AttachmentParser.parse_single(response)
         attachment.ticket_id = ticket_id
         attachment
      end
   end
end