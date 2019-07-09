
module Templet
  module Forms
    # Shows error messages from validation failures
    class BsFormErrors < Templet::Component::Partial
      include Constants

      def call(model)
        if model and model.errors.any?
          super() do
            div id: "error_expl", class: BS_PANEL do
              [ div(BS_PANEL_HEADING) { h3(error_title(model), BS_PANEL_TITLE) },

                div(BS_PANEL_BODY) do
                  ul(BS_LIST_UNSTYLED) do
                    model.errors.full_messages.map {|msg| li msg }
                  end
                end
              ]
            end
          end
        end
      end

      private

      def error_title(model)
        compose do
          error_count = model.errors.count
          model_name = model.class.name.underscore

          "#{pluralize error_count, "error"} on #{model_name}"
        end
      end
    end
  end
end

