
module Shared
  # Passed as model, but becomes model_name
  module ModelOption
    def self.included(base)
      desc = "The model to use inside the controller (instance variable and class)"

      base.class_eval do
        class_option :model, type: :string, aliases: "-m",
                             banner: 'singular name',
                             default: '', desc: desc
      end
    end

    private

    def model_name
      model_name? ? options['model'] : singular_name
    end

    def model_name?
      options['model'].present?
    end
  end
end
