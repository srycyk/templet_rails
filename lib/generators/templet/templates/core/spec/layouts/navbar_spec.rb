
require "rails_helper"

require 'app/layouts/navbar'

RSpec.describe App::Layouts::Navbar, type: :helper do
  include PartialTestHelpers

  it "includes title" do
    title = parse_html('nav div a', render_args: ["Role", []]).text

    expect(title).to eq("Role")
  end

  it '' do
#puts partial.inspect
#puts partial.call
  end
end
