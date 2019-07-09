
require_relative '../shared/parent_option'
require_relative '../shared/add_routes_option'
require_relative '../shared/actions_option'

module Templet
  class RoutesGenerator < Rails::Generators::NamedBase
    include Shared::ParentOption
    include Shared::AddRoutesOption
    include Shared::ActionsOption

    source_root File.expand_path('.', __FILE__)
    desc

    def add_routes
      routes = route_statement

      if add_routes?
        route routes

        puts 'Routes written to config/routes.rb as follows:', routes
      else
        puts 'If applicable, update your config/routes.rb file with:', routes
      end
    end

    private

    def route_statement
      in_scope { in_parent { resources plural_name, only_actions: true } }
    end

    def in_scope
      if scope_name
        "  namespace('#{scope_name}') do\n  #{yield}\n  end\n"
      else
        yield
      end
    end

    def in_parent
      if parent
        "  #{resources parent.pluralize, no_only: true} { #{yield} }"
      else
        "  #{yield}"
      end
    end

    def resources(name, **options)
      "resources(:#{name}#{only_actions **options})"
    end

    ONLY = ', only: '
    def only_actions(only_actions: false, no_only: false)
      only_actions ? action_syms(ONLY) : no_only ? "#{ONLY}[]" : ''
    end

    def scope_name
      elements = file_path.split('/')[0..-2]

      if elements.any?
        elements * '/'
      end
    end
  end
end
