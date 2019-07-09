
module Shared
  module ActionsOption
    def self.included(base)
      desc = "A list of REST action names - leave this out if you want them all"

      base.class_eval do
        class_option :actions, type: :array, aliases: "-a",
                               banner: 'index show create',
                               default: [], desc: desc
      end
    end

    private

    def actions
      options['actions'].any? ? options['actions'] : nil
    end

    def action_syms(prefix='')
      actions and "#{prefix}%i(#{actions * ' '})"
    end
  end
end
