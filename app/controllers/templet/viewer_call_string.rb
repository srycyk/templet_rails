
module Templet
  # Constructs a string of Ruby that, when executed, returns a string of HTML.
  #
  # It calls a method, named by the given +action+ parameter, on an instance
  # of the type: Templet::ViewerRest.
  #
  # The resultant code statement is executed within the view context
  # i.e. as if it's called from the inside of an ERb partial.
  #
  # It takes this circuitous route to pass various items from the controller
  # to the view e.g. instance variables, model names, link set controls.
  class ViewerCallString
    attr_accessor :action, :controller, :model_name, :parent,
                  :models, :use_model_name,
                  :grand_parent, :variables, :wrapper

    attr_accessor :viewer_class
    #
    # +action+:: The REST action, i.e. the controller method name
    #
    # +controller+:: The name without the suffix 'Controller', but may be prefixed with a scope/namespace
    #
    # +model_name+:: The model name, mirroring the model's instance variable
    #
    # +parent+:: An actual instance of a model's dependent, i.e. the belongs_to
    #
    # +models+:: A list of models, used in the index action, it names the instance variable
    #
    # +use_model_name+:: If true, no instance variable of the model is defined, e.g. in index and new
    #
    # +use_base+:: If true, it will render the view using the superclass, Templet::ApplicationRestViewer
    #
    # +class_name+:: The name of the Viewer class
    #
    # +module_name+:: The name of the Viewer module
    #
    # +grand_parent+:: The name of the parent's parent, for 'Back' buttons
    #
    # +variables+:: A list of instance variables to be passed into the view (no @ prefix)
    #
    # +wrapper+:: For specifying an HTML id, i.e. the target of a JS request
    #
    def initialize(action, model_name, controller: nil,
                                       parent: nil,
                                       models: nil,
                                       use_model_name: nil,
                                       use_base: false,
                                       class_name: nil,
                                       module_name: nil,
                                       grand_parent: nil,
                                       variables: [],
                                       wrapper: nil)
      self.action = action

      self.controller = controller

      self.model_name = model_name

      self.parent = parent

      self.models = models

      # Specify a model name as opposed to an instance in an instance variable
      # It's because there is no model in the actions 'index' and 'new'
      self.use_model_name = if use_model_name.nil?
                              models ? true : false 
                            else
                              use_model_name
                            end

      self.grand_parent = grand_parent

      self.variables = variables

      self.wrapper = wrapper

      self.viewer_class = ViewerCallStringClass.new(controller, model_name,
                                                    use_base,
                                                    class_name, module_name)
    end

    def call(action=action())
      "#{viewer_class}.new(#{args}#{opts}).#{action}"
    end

    alias to_s call

    private

    # Arguments

    def args
      "self" << model_arg << parent_arg
    end

    def model_arg
      prefix = use_model_name ? ':' : '@'

      to_arg(model_name, prefix)
    end

    def parent_arg
      to_arg(parent, '@')
    end

    def to_arg(value_name, value_prefix='')
      value_name ? ", #{value_prefix}#{value_name}" : ''
    end

    # Options

    def opts
      opts = controller_opt << models_opt << grand_parent_opt << wrapper_opt

      variables.reduce(opts) {|acca, variable| acca << to_opt(variable) }
    end

    def controller_opt
      controller ? to_opt("'#{controller}'", :controller, '') : ''
    end

    def models_opt
      to_opt(models, :models, models.to_s.start_with?('@') ? '' : '@')
    end

    def grand_parent_opt
      to_opt(grand_parent, :grand_parent)
    end

    def wrapper_opt
      to_opt((wrapper == false ? :none : wrapper), :wrapper)
    end

    def to_opt(value_name, key_name=nil, value_prefix=nil)
      value_prefix ||= key_name ? ':' : '@'

      key_name ||= value_name

      value_name ? ", #{key_name}: #{value_prefix}#{value_name}" : ''
    end
  end
end

