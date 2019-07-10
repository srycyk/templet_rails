
module Templet
  module Layouts
    # Renders a standard HTML layout
    # Basically, it's the same layout that Rails uses
    class HtmlRails < Templet::Component::Layout
      APP = 'application'

      TURBOS = { 'data-turbolinks-track' => true }

      SCALE = '<meta name="viewport" content="width=device-width, initial-scale=1.0">'

      DESC_TEMPLATE = '<meta name="description" content="%s">'

      def call(title, description='', head_extras: nil)
        super() do
          header = [ SCALE,
                     (DESC_TEMPLATE % description),
                     _title(title),
                     stylesheet_link_tag(APP, TURBOS.merge(media: 'all')),
                     javascript_include_tag(APP, TURBOS),
                     csrf_meta_tags,
                     head_extras,
                     rear_head ]

          html { [ head(header), body(yield renderer) ] }
        end
      end

      private

      def rear_head
      end
    end
  end
end
