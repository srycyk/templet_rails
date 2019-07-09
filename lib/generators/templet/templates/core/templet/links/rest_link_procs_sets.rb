
module Templet
  module Links
    # For grouping REST links together
    # Included in RestLinkProcs
    module RestLinkProcsSets
      def member_link_hash(field_names=%i(_show _edit _delete),
                             action_to_text: {})
        field_names.zip(member_links action_to_text: action_to_text).to_h
      end

      def collection_link_list(renderer, model_name: nil,
                                         model: nil, parent: nil)
        collection_links(model_name).map {|f| f.(renderer, model, parent) }
      end

      def member_links(params: nil, action_to_text: {})
        return show_link(action_to_text[:show], params: params),
               edit_link(action_to_text[:edit], params: params),
               delete_link(action_to_text[:delete], params: params)
      end

      def collection_links(name=nil, params: nil)
        return index_link(name, params: params),
               new_link(name, params: params)
      end
    end
  end
end

