
module Templet
  module Links
    # Returns REST paths as an Array
    class RestPath
      attr_accessor :model, :parent, :scope, :controller

      def initialize(model, parent=nil, scope: nil, controller: nil)
        self.model = model

        self.parent = parent

        self.scope = scope

        self.controller = controller
      end

      def action(name, params: nil, on_collection: false)
        [name] + (on_collection || on_collection? ? index(params) : show(params))
      end

      def for_form(params=nil)
        if model.persisted?
          return show(params), model
        else
          return index(params), model
        end
      end

      def index(params=nil)
        [ scope, parent, try_controller(plural), params ].compact
      end

      def show(params=nil)
        params = add_model_param(params) if controller

        [ scope, parent, try_controller(model, :singular), params ].compact
      end

      #def create(params=nil)
      #  [ scope, parent, try_controller(singular, :singular), params ].compact
      #end

      def new(params=nil)
        #%i(new) + create(params)
        [ :new, scope, parent, try_controller(singular, :singular), params ].compact
      end

      def edit(params=nil)
        %i(edit) + show(params)
      end

      #alias update show

      alias delete show
      alias destroy show

      private

      def on_collection?
        String === model || Symbol === model
      end

      def try_controller(default, inflection=:plural)
        inflect(controller, inflection) or default
      end
      def inflect(word, inflection)
        word and (inflection == :plural ? word : word.to_s.singularize)
      end

      def add_model_param(params=nil)
        (params || {}).merge id: model.to_param
      end

      def plural
        singular.to_s.pluralize.to_sym
      end

      def singular
        case model
        when String, Symbol
          model.to_sym
        else
          model.class.name.underscore.to_sym
        end
      end
    end
  end
end

