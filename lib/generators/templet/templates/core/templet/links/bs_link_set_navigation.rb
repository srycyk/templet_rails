
module Templet
  module Links
    # Returns a list of links for a model instance.
    # Has all the main buttons for REST actions.
    class BsLinkSetNavigation < BsLinkSetBase
      # Returns a list of 3 lists of REST links.
      #   The first is for parent links
      #   The second are links for the current model
      #   The third is a link pointing to an index of hildren
      # Note that this list is usually flattened.
      def call(action=nil)
        parents, current, children = [ [], [], [] ]

        # Ancestors
        if parent
          push parents, parent_link_proc(:index)

          push parents, parent_link_proc(:show)
        end

        # Current model

        link_proc_unless(:new, action, to: current)

        if have_instance?
          link_proc_unless(:edit, action, to: current)

          link_proc_unless(:show, action, to: current)

          push current, link_proc(:delete)
        end

        link_proc_unless(:index, action, to: current)

        # Descendants
        if have_instance?
          if forward
            push children, link_procs.index_link.(renderer, forward, model)

            singular = forward.to_s.singularize

            push children, link_procs.new_link.(renderer, singular, model)
          end
        end

        Array.new << parents << current << children
      end

      private

      def push_in(links, link, at: 1)
        links[at].push link if link
      end

      def have_instance?
        not (Symbol === model or String === model or model.new_record?)
      end
    end
  end
end

