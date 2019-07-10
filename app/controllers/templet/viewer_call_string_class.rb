
module Templet
  # Returns the name (as a string) of the Viewer class
  # It's used internally by ViewerCallString
  class ViewerCallStringClass < Struct.new(:controller, :model_name,
                                           :use_base, :class_name,
                                           :module_name)
    APP_MODULE = 'App' # Base namespace of the application subclasses

    VIEWER_CLASS_SUFFIX = "Viewer"

    VIEWER_BASE_CLASS = APP_MODULE + '::Base' + VIEWER_CLASS_SUFFIX

    def call
      if use_base
        VIEWER_BASE_CLASS
      elsif String === class_name
        class_name
      else
        subclass_name
      end
    end

    alias to_s call

    private

    # Reverts to the base class if there is no Viewer class that is either
    # explicitly given or is implicitly derived, e.g. from the controller's name
    def subclass_name
      subclass_name = application_subclass

      if (subclass_name.constantize rescue false)
        subclass_name
      else
        VIEWER_BASE_CLASS
      end
    end

    def application_subclass
      APP_MODULE + controller_module +
        (class_name || controller_name || model_name).to_s.classify +
        VIEWER_CLASS_SUFFIX
    end

    def controller_name
      if controller
        controller.to_s.split('/').last
      end
    end

    def controller_module
      if module_name
        "#{module_name.to_s.classify}::"
      elsif controller
        controller.to_s.split('/')[0..-2].reduce('') do |acca, name|
          acca << '::' << name.classify
        end << '::'
      else
        '::'
      end
    end
  end
end

