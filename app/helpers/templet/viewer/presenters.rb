
module Templet
  module Viewer
    # For rendering HTML tables and forms
    # Shortcuts to method calls in Templet::Mixins:HtmlPresenters
    # Supports Kaminari paging - as long as the gem's installed
    module Presenters
      def list(renderer)
        html_definition_list(renderer, show_controls, model)
      end

      def form(renderer)
        path = Links::RestPath.new model, parent, scope: controllers_path,
                                                  controller: controllers_name

        html_form(renderer, url: path, height: form_height)
      end

      def table(renderer, records=models, footer: nil)
        footer ||= pagination(renderer, records)

        html_table(renderer, index_controls, records, opaque_heading: model,
                                                      opaque_row: parent,
                                                      footer: footer)
      end

      private

      def pagination(renderer, records)
        if pagination? and records.respond_to? :current_page
          renderer.call do
            [ paginate(records),
              em(page_entries_info(records), 'small pull-right') ]
          end
        end
      end

      def pagination?
        defined? Kaminari
      end
    end
  end
end

