module Fiddler
   module Formatters
      class SearchRequestFormatter < BaseFormatter
         class << self
            def format(options={})
               result = Hash.new
               
               unless options.empty?
                  query = Array.new

                  add_array_or_single(options, query, :queue)
                  add_array_or_single(options, query, :status)
                  add_text_search_fields(options,query)
                  add_date_search_fields(options,query)

                  query << options[:conditions].to_s.chomp if options[:conditions]

                  result = { "query" => query.join(" AND "), :format => "l"}
               end
               result
            end

            protected

            def add_array_or_single(options, query_array, key)
               unless query_array and options and options.keys.include?(key)
                  return false
               end
               value = options[key]
               name = key.to_s.camelize
               if value.is_a?(Array)
                  sub_parts = Array.new
                  value.each do |part|
                     sub_parts << "#{name} = '#{part}"
                  end
                  query_array << '( ' + sub_parts.join(' OR ') + ' )'
               elsif value.is_a?(String) || value.is_a?(Symbol)
                  query_array << "#{name} = #{value.to_s}"
               end
            end

            def add_text_search_fields(options,query_array)
               text_fields = %w( subject content content_type file_name owner requestors cc admin_cc)
               options.each do |key, value|
                  if text_fields.include?(key.to_s)
                     key = key.to_s.camelize
                     parts = Array.new
                     if value.is_a?(Array)
                        value.each do |v|
                           parts << "#{key} LIKE '#{v}'"
                        end
                        query_array << '( ' + parts.join(" AND ") + ' )'
                     elsif value.is_a?(String)
                        # special case for when user is Nobody, like doesnt work there
                        if key == "Owner" and value == "Nobody"
                           query_array << "#{key} = '#{value}'"
                        else
                           query_array << "#{key} LIKE '#{value}'"
                        end
                     end
                  end
               end
            end

            def add_date_search_fields(options,query_array)
               date_field = %w( created started resolved told last_updated starts due updated )
               options.each do |key, value|
                  if date_field.include?(key.to_s)
                     key = key.to_s.camelize
                     parts = Array.new
                     if value.is_a?(Range) or value.is_a?(Array)
                        parts << "#{key} > '#{value.first.is_a?(Time) ? value.first.strftime("%Y-%m-%d %H:%M:%S") : value.first.to_s}'"
                        parts << "#{key} < '#{value.last.is_a?(Time) ? value.last.strftime("%Y-%m-%d %H:%M:%S") : value.last.to_s}'"
                     elsif value.is_a?(String)
                        parts << "#{key} > '#{value.to_s}'"
                     elsif value.is_a?(Time)
                        parts << "#{key} > '#{value.strftime("%Y-%m-%d %H:%M:%S")}'"
                     end
                     query_array << '( ' + parts.join(" AND ") + ' )'
                  end
               end
            end
         end
      end
   end
end