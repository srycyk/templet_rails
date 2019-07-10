
require "rails_helper"

RSpec.describe App::CategoryViewer, type: :helper do
  it_should_behave_like "a viewer" do
    let(:model_name) { :category }


    let(:field_name) { :name }

    let(:input_field_tag) { "input" }
  end
end

