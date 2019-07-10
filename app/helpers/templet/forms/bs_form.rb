
module Templet
  module Forms
    # Entry point for rendering forms
    # It writes out the HTML form tag, error meesages and hidden fields
    class BsForm < Templet::Component::Partial
      include Constants

      # Renders the outside of an HTML form
      # it renders the <form> tag, the model's errors, and two hiiden fields
      def call(url: nil,
               remote: false,
               html_class: nil,
               inline: false,
               method: nil)
        super() do
          url, model = url.for_form if url.respond_to?(:for_form)

          url = url_for(url) if Array === url or ActiveRecord::Base === url

          atts = form_atts(html_class, remote, inline, method)

          method ||= http_method(model)

          hidden_form_fields = if get?(method)
              []
            else
              [ hidden_field_tag(:authenticity_token, form_authenticity_token),
                hidden_field_tag(:_method, method) ]
            end

          [ BsFormErrors.new(self).(model),
            form(atts.merge action: url) { hidden_form_fields << yield(self) }
          ]
        end
      end

      # Shortcut method used in rendering a REST form with specified fields
      def self.call(renderer, record, **form_group_options)
        form_group = BsFormGroup.new(renderer, record, **form_group_options)

        return BsFormField.new(form_group), form_group
      end

      private

      def get?(method)
        method&.to_s =~ /get/i
      end

      def form_atts(html_class, remote, inline, method)
        html_class ||= form_class(inline)

        atts = { class: html_class, role: 'form' }

        atts[:method] = get?(method) ? 'get' : 'post'

        atts[:"data-remote"] = 'true' if remote

        atts
      end

      def form_class(inline=false)
        inline ? BS_FORM_INLINE : BS_FORM
      end

      def http_method(record)
        record&.persisted? ? 'patch' : 'post'
      end
    end
  end
end

