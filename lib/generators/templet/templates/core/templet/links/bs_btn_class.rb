
module Templet
  module Links
    # For Bootstrap link/button HTML classes
    class BsBtnClass < Struct.new(:type, :size)
      include Constants

      def call(type: type(), size: size())
        "#{BS_BUTTON} " +
          "#{BS_BUTTON}-#{type or default_type} " +
          "#{BS_BUTTON}-#{size or default_size}"
      end

      alias to_s call

      # Allows compatibily with an HTML class specifield in a String
      def +(suffix)
        suffix = suffix.to_s

        call + (suffix.start_with?(' ') ? '' : ' ') + suffix
      end

      class << self
        def call(html_class=nil)
          case html_class
          when String, self
            html_class
          when Symbol
            preset html_class
          when Array
            new *html_class
          else
            new
          end
        end

        def preset(name=nil)
          case name
          when :default
            new
          when :item
            Constants::BS_LIST_GROUP_ITEM
          else
            new name
          end
        end
      end

      private

      def default_type
        BS_BUTTON_TYPE
      end

      def default_size
        BS_BUTTON_SIZE
      end
    end
  end
end

