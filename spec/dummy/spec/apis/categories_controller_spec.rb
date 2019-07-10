
require "rails_helper"
require 'rack/test/methods'

RSpec.describe CategoriesController, type: :api do
  it_behaves_like "a json controller" do
    let(:model_singular) { :category }


    let(:field_name) { :name }
  end
end

