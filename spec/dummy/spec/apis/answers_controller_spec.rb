
require "rails_helper"
require 'rack/test/methods'

RSpec.describe AnswersController, type: :api do
  it_behaves_like "a json controller" do
    let(:model_singular) { :answer }

    let(:parent_name) { :question }

    let(:grand_parent_name) { :category }


    let(:field_name) { :reply }
  end
end

