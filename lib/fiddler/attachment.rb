require 'active_attr'
module Fiddler
   class AttachmentCollection < Array
      def to_payload
         hash = Hash.new
         self.each_with_index do |attach, index|
            hash["attachment_#{index+1}"] = attach
         end
         hash
      end

      def self.fill(*args)
         attachments = AttachmentCollection.new
         args.each do |attachment|
            if attachment.is_a?(File)
               attachments << attachment
            elsif attachment.is_a?(String)
               attachments << File.new(attachment)
            elsif attachment.respond_to?(:open, :original_filename)
               attachments << attachment
            end
         end
         attachments
      end
   end
   
   # the attachment in itself
   class Attachment
      include ActiveAttr::Model

      attribute :id
      attribute :subject
      attribute :creator
      attribute :created
      attribute :transaction
      attribute :parent
      attribute :message_id
      attribute :filename
      attribute :content_type
      attribute :content_encoding
      attribute :headers
      
      attr_accessor :ticket_id, :content, :path

      # Public class method to get an attachment
      def self.get(id, ticket_id)
         url = "/ticket/#{ticket_id}/attachments/#{id}"
         response = Fiddler::ConnectionManager.get(url)
         attachment = Fiddler::Parsers::AttachmentParser.parse_single(response)
         attachment.ticket_id = ticket_id
         attachment
      end

      def content_length
         length = header_value_for_key("Content-Length")
         if !length.nil?
            length.to_i
         elsif @content.nil?
            -1
         else
            @content.length
         end
      end

      def content
         populate_data
         @content
      end

      def path
         populate_data
         @path
      end

      def has_text_content
         if content_type == "text/plain" or content_type == "text/html"
            return true
         else
            return false
         end
      end

      protected

      def populate_data
         @data_populated ||= false
         unless @data_populated
            if content_length != 0
               if has_text_content
                  load_content
                  @path = nil
               else
                  @path = full_path_for_filename
                  if File.exists?(@path)
                     @content = ""
                  else
                     load_content
                     save_content_to_file
                  end
               end
            else
               @content = ""
            end
            @data_populated = true
         end
      end

      def load_content
         url = "/ticket/#{ticket_id}/attachments/#{id}/content"
         response = Fiddler::ConnectionManager.get(url)
         @content = Fiddler::Parsers::AttachmentParser.parse_content(response)
      end

      def header_value_for_key(header_key)
         final_value = nil
         headers.each do |header_line|
            (key,value) = header_line.split(":")
            if header_key == key
               final_value = value
               break
            end
         end
         return final_value
      end

      def save_content_to_file
         File.open(full_path_for_filename, "w") { |f| f.write(@content) }
         @content = ""
      end

      def full_path_for_filename
         "#{Fiddler.configuration.attachments_path}/#{id}-#{filename}"
      end
   end
end