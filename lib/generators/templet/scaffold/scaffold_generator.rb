
require_relative '../shared/model_option'
require_relative '../shared/parent_option'
require_relative '../shared/grand_parent_option'
require_relative '../shared/child_option'
require_relative '../shared/add_routes_option'
require_relative '../shared/comment_tests_option'
require_relative '../shared/actions_option'

module Templet
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include Shared::ModelOption
    include Shared::ParentOption
    include Shared::GrandParentOption
    include Shared::ChildOption
    include Shared::CommentTestsOption
    include Shared::AddRoutesOption
    include Shared::ActionsOption

    source_root File.expand_path('.', __FILE__)
    desc

    def create_controller
      generate 'templet:controller', args(name, parent_option, model_option,
                                          grand_parent_option, actions_option)
    end

    def create_viewer_subclass
      generate 'templet:viewer', args(name, child_option, actions_option)
    end

    def create_rspec
      generate 'templet:rspec', args(name, parent_option, model_option,
                                     grand_parent_option,
                                     comment_tests_option, actions_option)
    end

    def create_routes
      generate 'templet:routes', args(name, parent_option,
                                      add_routes_option, actions_option)
    end

    private

    def args(*options)
      options * ' ' + ' '
    end

    def parent_option
      parent ? "--parent #{parent}" : ''
    end

    def model_option
      model_name? ? "--model #{model_name}" : ''
    end

    def grand_parent_option
      grand_parent ? "--grand-parent #{grand_parent}" : ''
    end

    def child_option
      child? ? "--child #{child}" : ''
    end

    def add_routes_option
      add_routes? ? "--add-routes" : ''
    end

    def comment_tests_option
      comment_tests? ? '' : "--no-comment-tests"
    end

    def actions_option
      actions&.any? ? "--actions #{actions * ' '}" : ''
    end
  end
end
