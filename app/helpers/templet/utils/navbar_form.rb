
module Templet
  module Utils
    # Renders a Bootstrap navbar form for string searches.
    class NavbarForm < Templet::Component::Partial
      include Constants

      include Mixins::Bs

      def call(url, field_name: 'q', submit_text: 'Search', remote: false)
        super() do
          form action: url, class: "navbar-form navbar-left", role: "search" do
            div class: "form-group" do
              [ input(name: field_name, type: "text", value: params[field_name],
                      class: "form-control", placeholder: "Name"),
                button(submit_text, type: "submit", class: "btn btn-default") ]
            end
          end
        end
      end

      private

    end
  end
end
