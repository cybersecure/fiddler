require 'active_attr'
module Fiddler
   class History
      include ActiveAttr::Model

      attribute :id
      attribute :ticket
      attribute :time_taken
      attribute :type
      attribute :field
      attribute :old_value
      attribute :new_value
      attribute :data
      attribute :description
      attribute :content
      attribute :creator
      attribute :created
      attribute :attachment_ids
      
      attr_reader :attachments

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