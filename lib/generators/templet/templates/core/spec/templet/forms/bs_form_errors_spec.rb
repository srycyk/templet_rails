
require "rails_helper"

require 'templet/forms/bs_form_errors'

RSpec.describe Templet::Forms::BsFormErrors, type: :helper do
  include PartialTestHelpers

  let(:model) { build(:category, name: '').tap {|model| model.valid? } }

  it "shows error message" do
    selector = 'div[id=error_expl] ul li:first'

    message = parse_html(selector, render_args: [model]).text

    expect(message).to match %r(Name.+blank)
  end
end
