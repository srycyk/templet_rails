
module Shared
  module ChildOption
    def self.included(base)
      desc = "A direct descendant of the model - the principal has_many record type"

      base.class_eval do
        class_option :child, type: :string, aliases: "-c", default: nil,
                             banner: 'singular name', desc: desc
      end
    end

    private

    def child
      options['child']
    end

    def child?
      child and child.present?
    end
  end
end
