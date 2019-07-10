
require "rails_helper"

require 'app/layouts/panel/flash_messages'

RSpec.describe App::Layouts::Panel::FlashMessages, type: :helper do
  include PartialTestHelpers

  it "shows notice" do
    html = partial(flash: {notice: 'Final'}).(cols: 9, offset: 2)

    selector = 'div[class=row] div[id=flash_notice]'

    notice = parse_html(selector, html: html).text

    expect(notice).to eq("Final")
  end
end
