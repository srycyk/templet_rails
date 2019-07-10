
require "rails_helper"

RSpec.describe App::AnswerViewer, type: :helper do
  it_should_behave_like "a viewer" do
    let(:model_name) { :answer }

    let(:parent_name) { :question }

    let(:grand_parent_name) { :category }


    let(:field_name) { :reply }

    let(:input_field_tag) { "textarea" }
  end
end

