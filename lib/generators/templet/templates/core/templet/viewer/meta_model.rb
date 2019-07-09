
module Templet
  module Viewer
    # Model introspection
    class MetaModel < Struct.new(:model_proto)
      def names
        #dictionary {|column| column.name.to_sym }
        field_info.map(&:name).map(&:to_sym)
      end

      def listing_names
        names.reject do |name|
          %i(id created_at updated_at).include?(name) or name.to_s =~ /_id$/
        end
      end

      def input_names
        listing_names
      end

      def type(name)
        (@types ||= types)[name]
      end

      def types
        dictionary &:type
      end

      def input(name)
        type = type(name)

        inputs[type] or type
      end

      def inputs
        { string: :text, text: :text_area, boolean: :check_box, integer: :text }
      end

      def field_info
        model_class.content_columns
      end

      private

      def dictionary
        field_info.inject Hash.new do |acc, column|
          acc[column.name.to_sym] = yield column

          acc
        end
      end

      def model_class
        case model_proto
        when Class
          model_proto
        when String, Symbol
          model_proto.to_s.classify.constantize
        else
          model_proto.class
        end
      end
    end
  end
end

