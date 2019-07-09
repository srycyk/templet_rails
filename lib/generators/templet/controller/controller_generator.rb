
require_relative '../shared/parent_option'
require_relative '../shared/grand_parent_option'
require_relative '../shared/model_option'
require_relative '../shared/actions_option'
require_relative '../shared/model_fields'

module Templet
  class ControllerGenerator < Rails::Generators::NamedBase
    include Shared::ModelOption
    include Shared::ParentOption
    include Shared::GrandParentOption
    include Shared::ActionsOption

    include Shared::ModelFields

    TEMPLATE_FILE = 'controller.rb.erb'

    SET_MODEL_ACTIONS = %w(show edit update destroy)

    source_root File.expand_path('.', __FILE__)
    desc

    source_root File.expand_path('../../templates', __FILE__)

    def create_controller
      template TEMPLATE_FILE, controller_path
    end

    private

    def include_action?(action)
      if actions
        actions.include? action.to_s
      else
        true
      end
    end

    def before_action(name, only=nil, prefix: "\n  ")
      return unless name

      suffix = only&.any? ? ', only: %i(' + only * ' ' + ')' : ''

      "#{prefix}before_action :set_#{name}#{suffix}\n"
    end

    def set_model?
      not actions or set_model_actions.any?
    end

    def set_model_actions
      actions ? SET_MODEL_ACTIONS & actions : SET_MODEL_ACTIONS
    end

    def controller_path
      File.join("app/controllers", "#{file_path.pluralize}_controller.rb")
    end

    def model_plural
      model_name.pluralize
    end

    def model_class_name
      model_name.classify
    end

    def receiver
      parent ? "@#{parent}.#{model_plural}" : model_class_name
    end

    def redirect_path(use_instance=true)
      if parent
        params = ", id: @#{model_name}" if model_name? and use_instance

        "[#{path_scope}@#{parent}, #{path_element use_instance}#{params}]"
      else
        "[#{path_scope}#{path_element false}]"
      end
    end

    def path_scope
      elements = file_path.split('/')[0..-2]

      if elements.any? 
        (elements.size == 1 ? ":#{elements.first}" : "'/#{elements * "/"}'") + ', '
      end
    end

    def path_element(use_instance)
      if use_instance
        (model_name? ? ':' : '@') + singular_name
      else
        ":#{plural_name}"
      end
    end

    def path_controller(prefix=nil)
      parents = [ parent.pluralize, '1' ] if parent

      [ *file_path.split('/')[0..-2], *parents, plural_name, *prefix ] * '/'
    end

    def to_option(key, name, prefix='')
      name ? "#{prefix}#{key}: :#{name}" : ''
    end
  end
end
