module Fiddler
   class Attachment
      DefaultAttributes = %w(id subject creator created transaction parent message_id filename content_type content_encoding headers).inject({}){|memo, k| memo[k] = nil; memo}
      
      attr_accessor :ticket_id, :content, :path
      
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
         @path = nil
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

      def content_length
         length = 0
         headers.each do |header_line|
            (key,value) = header_line.split(":")
            if key == "Content-Length"
               length = value.to_i
               break
            end
         end
         return length
      end

      def content
         if @content == nil
            if content_length > 0
               if not has_text_content and File.exists?(path)
                  @content = ""
                  return @content
               end
               url = "/ticket/#{ticket_id}/attachments/#{id}/content"
               response = Fiddler::ConnectionManager.get(url)
               @content = Fiddler::Parsers::AttachmentParser.parse_content(response)
               save_content_to_file unless has_text_content
            else
               @content = ""
            end
         end
         @content
      end

      def path
         "#{Fiddler.configuration.attachments_path}/#{filename}"
      end

      def save_content_to_file
         if File.exists?(path)
            File.unlink(path)
         end
         File.open(path, "w") { |f| f.write(@content) }
         @content = ""
      end

      def has_text_content
         if content_type == "text/plain" or content_type == "text/html"
            return true
         else
            return false
         end
      end

      def self.get(id, ticket_id)
         url = "/ticket/#{ticket_id}/attachments/#{id}"
         response = Fiddler::ConnectionManager.get(url)
         attachment = Fiddler::Parsers::AttachmentParser.parse_single(response)
         attachment.ticket_id = ticket_id
         attachment
      end

      def to_s
         puts @attributes.inspect
      end
   end
end