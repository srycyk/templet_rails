
require_relative '../shared/parent_option'
require_relative '../shared/grand_parent_option'
require_relative '../shared/model_option'
require_relative '../shared/comment_tests_option'
require_relative '../shared/model_fields'
require_relative '../shared/actions_option'

class Templet::RspecGenerator < Rails::Generators::NamedBase
  FILL_IN = 'FILL_IN_FIELD_NAME'

  include Shared::ParentOption
  include Shared::GrandParentOption
  include Shared::ModelOption
  include Shared::CommentTestsOption
  include Shared::ActionsOption

  include Shared::ModelFields

  viewer_desc = "Create a spec file containing tests for the viewer class"
  class_option 'viewer-tests', type: :boolean, aliases: "-v",
                               default: true, desc: viewer_desc

  source_root File.expand_path('.', __FILE__)
  desc

  def create_viewer
    create_file viewer_path, viewer_spec if viewer_tests?
  end

  def create_controller_api
    create_file controller_api_path, controller_api_spec
  end

  private

  def viewer_path
    "spec/helpers/app/#{file_path}_viewer_spec.rb"
  end

  def viewer_tests?
    options['viewer-tests']
  end

  def controller_api_path
    "spec/apis/#{file_path.pluralize}_controller_spec.rb"
  end

  def assign_overrides
    "#{assign_parent}#{assign_grand_parent}#{assign_scope}#{assign_controller}"
  end

  def assign_parent
    parent ? "    let(:parent_name) { :#{parent} }\n\n" : ""
  end

  def assign_grand_parent
    grand_parent ? "    let(:grand_parent_name) { :#{grand_parent} }\n\n" : ""
  end

  def assign_scope
    elements = file_path.split('/')[0..-2]

    if elements.any?
      scope = elements * '/'

      scope ? "    let(:scope) { '#{scope}' }\n\n" : ""
    end
  end

  def assign_controller
    controller_name = file_path.split('/').last

    if controller_name != model_name
      "    let(:controller_name) { '#{controller_name.pluralize}' }\n\n"
    end
  end

  def comment(name=:begin)
    comment_tests? ? "\n=#{name}" : ''
  end

  def viewer_spec
    name = model_name || singular_name

    input_field, input_field_tag = textual_field_with_tag name

    %Q[
require "rails_helper"
#{comment}
RSpec.describe App::#{class_name}Viewer, type: :helper do
  it_should_behave_like "a viewer"#{action_syms ', '} do
    let(:model_name) { :#{name} }

#{assign_overrides}
    let(:field_name) { :#{input_field || FILL_IN} }

    let(:input_field_tag) { "#{input_field_tag || FILL_IN}" }
  end
end
#{comment :end}
]
  end

  def controller_api_spec
    name = model_name || singular_name

    input_field, _ = textual_field_with_tag name

    %Q[
require "rails_helper"
#{comment}
RSpec.describe #{class_name.pluralize}Controller, type: :api do
  it_behaves_like "a json controller"#{action_syms ', '} do
    let(:model_singular) { :#{name} }

#{assign_overrides}
    let(:field_name) { :#{input_field || FILL_IN} }
  end
end
#{comment :end}
]
  end
end
