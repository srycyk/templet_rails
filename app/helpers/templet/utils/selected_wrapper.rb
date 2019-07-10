
module Templet
  module Utils
    # Wraps (in a tag) some given content according to a condition.
    class SelectedWrapper
      attr_accessor :wrapper, :selected_class

      def initialize(wrapper, selected_class)
        self.selected_class = selected_class

        self.wrapper = get_wrapper wrapper
      end

      def call(content, is_selected=false)
        if wrapper
          wrapper[is_selected ? :selected : :regular] % content
        else
          content
        end
      end

      private

      def get_wrapper(wrapper)
        if wrapper
          if Hash === wrapper
            wrapper
          else
            { regular: tag(wrapper),
              selected: tag(wrapper, " class='#{selected_class}'") }
          end
        end
      end

      def tag(name, atts_string='')
         "<#{name}#{atts_string}>%s</#{name}>"
      end
    end
  end
end
