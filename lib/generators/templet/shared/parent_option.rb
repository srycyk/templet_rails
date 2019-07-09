
module Shared
  module ParentOption
    def self.included(base)
      desc = "The model's dependent - the record type the model belongs_to"

      base.class_eval do
        class_option :parent, type: :string, aliases: "-p",
                              banner: 'singular name',
                              default: '', desc: desc
      end
    end

    private

    def parent
      options['parent'].present? ? options['parent'] : nil
    end
  end
end
