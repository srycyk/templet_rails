
module Templet
  module Forms
    # Renders the different types of HTML input fields
    class BsFormField < Struct.new(:form_group)
      include Constants

      def text(field_name, mandatory: false, help: nil)
        field_class = field_class()

        group_opts = { mandatory: mandatory, help: help }

        form_group.(field_name, **group_opts) do |renderer, record_name|
          renderer.call do
            text_field record_name, field_name, class: field_class
          end
        end
      end

      def text_area(field_name, rows: 2, mandatory: false, help: nil)
        field_class = field_class()

        group_opts = { mandatory: mandatory, help: help }

        form_group.(field_name, **group_opts) do |renderer, record_name|
          renderer.call do
            text_area record_name, field_name, class: field_class, rows: rows
          end
        end
      end

      def check_box(field_name, help: nil)
        form_group.(field_name, help: help) do |renderer, record_name|
          renderer.call do
            check_box record_name, field_name
          end
        end
      end

      def check_box_inline(field_name, help: nil)
        form_group.checkbox(field_name, help: help) do |renderer, record_name|
          renderer.call do
            check_box record_name, field_name
          end
        end
      end

      def select(field_name, selections, select_id: :id,
                                         select_name: :name,
                                         include_blank: false,
                                         size: nil,
                                         help: nil)
        html_options = { class: field_class }

        group_opts = { input_size: size, help: help }

        options = { include_blank: include_blank }

        form_group.(field_name, **group_opts) do |renderer, record_name|
          renderer.call do
            collection_select record_name, field_name,
                              selections, select_id, select_name,
                              options, html_options
          end
        end
      end

      DATE_INLINE_STYLE = 'display: inline; width: auto; float: left;'

      def date(field_name, include_blank: true, help: nil)
        html_options = { class: field_class, style: DATE_INLINE_STYLE }

        options = { include_blank: include_blank }

        form_group.(field_name, help: help) do |renderer, record_name|
          renderer.call do
            date_select record_name, field_name, options, html_options
          end
        end
      end

      def datetime(field_name, include_blank: true, help: nil)
        html_options = { class: field_class, style: DATE_INLINE_STYLE }

        options = { include_blank: include_blank,
                    datetime_separator: '', time_separator: '' }

        form_group.(field_name, help: help) do |renderer, record_name|
          renderer.call do
            datetime_select record_name, field_name, options, html_options
          end
        end
      end

      def submit(text: 'Submit', html_class: BS_BUTTON_SUBMIT,
                 offset: nil, height: form_group.height)
        html_class += " btn-#{height}" if height

        offset ||= form_group.label_cols

        form_group.renderer.call do
          submit_button = button(text, html_class, type: 'submit')

          div(:form_group) { div submit_button, "#{BS_COL_OFFSET}#{offset}" }
        end
      end

      def field_class
        form_group.field_class
      end
    end
  end
end

