
module Templet
  module Mixins
    # Helper methods for rendering HTML tables, forms and lists
    module HtmlPresenters
      include Constants

      # Html table

      # +controls+:: Is a Hash of field name by Proc which is passed a record
      def html_table(renderer, controls, records, **options)
        unless options.key? :html_class
          options[:html_class] = default_table_class
        end

        Templet::Html::Table.new(renderer).(controls, records, **options)
      end

      def default_table_class
        BS_TABLE
      end

      # Renders the outside of an HTML form.
      # Usually you feed it a block to specify the various fields.
      def html_form(renderer, form_opts, **group_opts)
        if not form_opts.key?(:remote) and respond_to?(:remote?) and remote?
          form_opts[:remote] = true
        end

        height = form_opts.delete(:height) || group_opts[:height]
        group_opts[:height] = height

        Forms::BsForm.new(renderer).(**form_opts) do |renderer|
          field, group = Forms::BsForm.(renderer, model, **group_opts)

          if block_given?
            yield field, group
          else
            form_inputs(field, group) << field.submit
          end
        end
      end

      # Html lists

      # +controls+:: A Hash of field name by Proc which is paassed a model
      def html_definition_list(renderer, controls, record=nil)
        Templet::Html::DefinitionList.new(renderer)
          .(controls, record, html_class: 'dl-horizontal')
      end

       # +items+ is an Array of (literal) list elements
      def html_list(renderer, items, html_class: nil, item_class: nil)
        html_class = get_list_class(html_class)

        Templet::Html::List.new(renderer).(items, html_class: html_class,
                                                  item_class: item_class)
      end

      def get_list_class(html_class)
        case html_class
        when nil, :default, :inline
          default_list_class
        when true, :stacked
          stacked_list_class
        when false, :none
        else
          html_class
        end
      end

      def default_list_class
        BS_LIST_INLINE
      end

      def stacked_list_class
        BS_LIST_UNSTYLED
      end
    end
  end
end

