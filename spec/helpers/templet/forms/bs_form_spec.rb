
require "rails_helper"

require 'templet/forms/bs_form'

RSpec.describe Templet::Forms::BsForm, type: :helper do
  include PartialTestHelpers

  include ModelParentHelpers

  def rest_path(model, parent=nil, **options)
    Templet::Links::RestPath.new model, parent, **options.merge(scope: scope)
  end

  def parse_form_html(selector, model)
    path = rest_path(model, parent)

    html = render_partial(url: path) {}

    parse_html(selector, html: html)
  end

  def expect_action(url_matcher, model=model())
    selector = 'form[role=form]'

    action = parse_form_html(selector, model)['action']

    expect(action).to match url_matcher
  end

  def expect_method(http_method, model=model())
    selector = 'input[name=_method]'

    method_value = parse_form_html(selector, model)['value']

    expect(method_value).to eq http_method
  end

  describe 'form action' do
    it "has new model url" do
      expect_action path_re, new_model
    end

    it "has persisted model url" do
      expect_action path_re(suffix: '/\d+')
    end
  end

  describe 'form method' do
    it "is POST for new model" do
      expect_method 'post', new_model
    end

    it "is PATCH for persisted model" do
      expect_method 'patch'
    end
  end
end
