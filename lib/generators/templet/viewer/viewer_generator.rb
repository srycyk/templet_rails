
require_relative '../shared/child_option'
require_relative '../shared/actions_option'

module Templet
  class ViewerGenerator < Rails::Generators::NamedBase
    include Shared::ChildOption
    include Shared::ActionsOption

    source_root File.expand_path('./', __FILE__)
    desc

    def create_viewer_subclass
      create_file "app/helpers/app/#{file_path}_viewer.rb", class_definition
    end

    private

    def have_actions?
      actions
    end

    def index_controls_method
      return unless have_actions?

      %Q[
      # For showing links to member actions (show edit destroy) in table rows
      def index_controls
        links = default_rest_link_procs.member_link_hash %i(#{member_actions})

        hash_field_name_by_proc_call_method_default.merge links
      end
]
    end

    def member_actions
      (%w(show edit delete destroy) & actions).map {|action| "_#{action}" }
          .join(' ')
    end

    def forward_method
      return unless child

      %Q[
      # Used in button groups for links to a model's children
      def forward
#{child? ? '        :' + child.pluralize : ''}
      end
]
    end

    def verify_rest_links_method
      return unless have_actions?

      %Q[
      # Checks whether a REST link is actually defined before displaying it
      def verify_rest_links?
        true
      end
]
    end

    def class_definition
      %Q[
module App
    class #{class_name}Viewer < BaseViewer
#{index_controls_method}
      private
#{forward_method}
#{verify_rest_links_method}
      # You can override the following methods:
      #
      # remote?     For AJAX links and forms
      # form_height For the field height on the form (sm md lg)
      # forward     For the model's principal has_many relationship
      # backward    For the model's grand-parent
      #             This can be overriden in the controller
      #
      # There are also a number of others, mostly to do with the layout
      #
      # For more info see: app/helpers/templet/viewer_base.rb
      #                    app/helpers/templet/viewer_rest.rb
    end
end
]
    end
  end
end
