
#require 'app/panel/main'

module Templet
  # The principal class which carries out the default HTML rendering
  # It is an entry point, even though it's mostly is used as a superclass
  class ViewerRest < ViewerBase
    include Viewer

    include Mixins
    include Mixins::Bs

    include Templet::Constants

    attr_accessor :model, :parent, :grand_parent, :controller, :models

    attr_accessor :meta_model

    def initialize(contexts, model=nil, parent=nil, **locals)
      self.model = model

      self.parent = parent || locals[:parent]

      self.controller = locals[:controller]&.to_s

      self.grand_parent = locals[:grand_parent] || backward

      self.models = locals[:models] || []

      self.meta_model = Viewer::MetaModel.new(model)

      locals.merge!(view_variables)

      super contexts, **locals
    end

    private

    # These values become global methods for accessing inside the view
    def view_variables
      { model: model,
        parent: parent,
        controllers_name: controllers_name,
        controllers_path: controllers_path,
        grand_parent: grand_parent,
        forward: forward,
        link_set_args_proc: link_set_args_proc }
    end

    def controllers_name
      if controller
        controller_name = controller.split('/').last.to_s

        if controller_name != plural_model
          return controller_name
        end
      end
    end

    def controllers_path
      if controller
        paths = controller.split('/').tap {|paths| paths.pop }

        if paths.any?
          paths.join('/')
        end
      end
    end

    def plural_model
      if model.respond_to?(:model_name)
        model.model_name.plural
      else
        model.to_s.pluralize
      end
    end

    # Returns the arguments used to construct Templet::Links::BsLinkSetBase
    # whose subclasses render REST links in menus and button groups
    def link_set_args_proc
      -> (renderer, options) {
        options.reverse_merge! scope: namespace,
                               controller: controllers_name,
                               remote: remote?,
                               verify_links: verify_rest_links?

        [ renderer, model, parent, grand_parent, forward, **options ]
      }
    end

    def namespace
      scope or controllers_path
    end

    # The remaining methods are for overriding, there are more in the superclass

    # Layouts

    def panel_title
      if model
        case model
        when String, Symbol
          model.to_s
        else
          model.class.name
        end
      else
        super.sub('Rest', '')
      end.humanize.pluralize
    end

    # General

    # Height of form fields
    def form_height
      'md'
    end

    # Use JS (AJAX) for form submissions, and REST links of the index table
    def remote?
    end

    # Name of model's grand parent (underscored)
    # Used for 'Back' buttons
    def backward
    end

    # Name (underscored) of model's child
    # Used for (index) links that list children
    def forward
    end

    # For use in specifying a namespace in links
    def scope
    end

    # Set to true if the controller does not support all REST actions,
    # for example, if just index and show are available
    def verify_rest_links?
      false
    end
  end
end

