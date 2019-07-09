
module Templet
  module Forms
    # Renders the various tags that surround a Bootstrap form field
    class BsFormGroup < Templet::Component::Partial
      include Constants

      MANDATORY_MARKER = ' *'

      NBSP = ' &nbsp; '

      attr_accessor :record, :record_name

      attr_accessor :field_cols, :input_cols, :height

      attr_accessor :label_cols, :hide_label

      def initialize(renderer, record, record_name: record.model_name.singular,
                                       field_cols: 12,
                                       input_cols: 8,
                                       label_cols: 2,
                                       height: nil,
                                       hide_label: false)
        super(renderer)

        self.record = record

        self.record_name = record_name

        self.field_cols = field_cols
        self.input_cols = input_cols

        self.height = height

        self.label_cols = label_cols

        self.hide_label = hide_label
      end

      # An alternative constructor for plain (usually inline) forms
      def self.call(renderer, model=nil, hide_label: true, height: 'md')
        new renderer, model, record_name: '',
                             field_cols: nil,
                             input_cols: nil,
                             label_cols: nil,
                             height: height,
                             hide_label: hide_label
      end

      def call(field_name, label_name: nil, field_size: nil,
                           input_size: nil, label_size: nil,
                           mandatory: false, help: nil)
        label_name ||= field_name.to_s.sub(/_id$/, '').tr('_', ' ').capitalize

        label_name += mandatory ? MANDATORY_MARKER : ''

        field_class = "form-group #{col_class field_size || field_cols}"

        if hide_label
          label_class = "sr-only"
        else
          label_class = "control-label #{col_class label_size || label_cols}"

          label_class += height ? " input-#{height}" : ''
        end

        input_class = col_class(input_size || input_cols)

        inner_self = self

        renderer.call do
          div(field_class) do
            [ label(record_name, field_name, label_name, class: label_class),
              div(input_class) do
                [ yield(self, record_name, inner_self), *help_block(help) ]
              end
            ]
          end
        end
      end

      # Checkboxes can be rendered with a different form-group layout
      def checkbox(field_name, text=field_name.to_s.capitalize, help: nil)
        inner_self = self

        renderer.call do
          div("form-group #{col_class field_cols}") do
            div :checkbox do
              _label col_class(label_cols, offset: true) do
                [ NBSP,
                  yield(self, record_name, inner_self),
                  text,
                  help_block(help) || '<br><br>'
                ]
              end
            end
          end
        end
      end

      def help_block(help)
        "<p class='help-block'>#{help}</p>" if help
      end

      def col_class(cols, offset=false)
        "#{offset ? BS_COL_OFFSET : BS_COL}#{cols}" if cols
      end

      def field_class
        'form-control' + (height ? " input-#{height}" : '')
      end
    end
  end
end

