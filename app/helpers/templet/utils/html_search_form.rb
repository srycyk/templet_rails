
module Templet
  module Utils
    # Renders a form (inline) for string searches, primarily for index actions.
    class HtmlSearchForm < Templet::Component::Partial
      include Constants

      include Mixins::Bs

      def call(url, field_name: 'q', submit_text: 'Search',
                    label: nil, remote: false)
        label ||= submit_text.underscore

        super() do
          Forms::BsForm.new(renderer).(**form_opts(url, remote)) do |renderer|
            group = Forms::BsFormGroup.(renderer)

            btn_class = "#{BS_BUTTON_SUBMIT_SEARCH} #{BS_BUTTON}-#{group.height}"
            submit = button(submit_text, btn_class, type: 'submit')

            [
              group.(field_name, label_name: label) do |renderer, record_name|
                renderer.call do
                  text_field record_name, field_name, value: params[field_name],
                                                      class: group.field_class
                end
              end,
              submit
            ]
          end
        end
      end

      def self.call(renderer, model, parent=nil, scope: nil,
                                                 action: nil,
                                                 remote: nil)
        rest_path = Links::RestPath.new(model, parent, scope: scope)

        path = action ? rest_path.action(action) : rest_path.index

        new(renderer).(path, remote: remote)
      end

      private

      def form_opts(url, remote=nil)
        { url: url, inline: true, method: 'get' }.tap do |options|
          options.merge!(remote: true) if remote
        end
      end
    end
  end
end
