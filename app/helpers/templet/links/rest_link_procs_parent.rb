
module Templet
  module Links
    # For REST links to a model's parent
    # Included in RestLinkProcs
    module RestLinkProcsParent
      def index_parent_link(**options)
        link_to_parent :index, **options
      end

      def show_parent_link(**options)
        link_to_parent :show, **options
      end

      def new_parent_link(**options)
        link_to_parent :new, **options
      end

      def edit_parent_link(**options)
        link_to_parent :edit, **options
      end

      private

      def link_to_parent(action, grand_parent: nil, text: nil, params: nil)
        -> renderer, _, parent {

          text ||= link_text.parent_text(action, parent)

          grand_parent = grand_parent && parent.send(grand_parent)

          send("#{action}_link", text, params: params)
              .(renderer, parent, grand_parent)
        }
      end
    end
  end
end

