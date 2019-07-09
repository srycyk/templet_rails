
module Shared
  module AddRoutesOption
    def self.included(base)
      desc = "Update the the file config/routes.rb"

      base.class_eval do
        class_option 'add-routes', type: :boolean, aliases: "-r",
                                   default: false, desc: desc
      end
    end

    private

    def add_routes?
      options['add-routes']
    end
  end
end
