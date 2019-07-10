
module Templet
  module Links
    # Returns a list of REST links when there's no model instance.
    # For the buttons: back, index & new
    class BsLinkSetCollection < BsLinkSetBase
      def call(action=nil)
        links = []

        links << parent_link_proc(:index) if parent

        link_proc_unless(:index, action, to: links)

        link_proc_unless(:new, action, to: links)

        links
      end
    end
  end
end

