module Fiddler
   class History
      DefaultAttributes = %w(id ticket time_taken type field old_value new_value data description content creator created attachment_ids).inject({}){|memo, k| memo[k] = nil; memo}
      
      attr_reader :attachments
      
      # Initializes a new instance of history object
      #
      # @params [Hash] of the initial options
      def initialize(attributes={})
         if attributes
            @attributes = DefaultAttributes.merge(attributes)
         else
            @attributes = DefaultAttributes
         end
         @attachments = nil
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

      def attachments
         if @attachments == nil
            @attachments = []
            attachment_ids.each do |id|
               @attachments << Fiddler::Attachment.get(id,ticket)
            end
         end
         @attachments
      end
   end
end