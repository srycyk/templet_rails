
module Shared
  module GrandParentOption
    def self.included(base)
      desc = "The parent's dependent - the record type the parent belongs to"

      base.class_eval do
        class_option 'grand-parent', type: :string, aliases: "-g",
                                     banner: 'singular name',
                                     default: '', desc: desc
      end
    end

    private

    def grand_parent
      options['grand-parent'].present? ? options['grand-parent'] : nil
    end
  end
end
