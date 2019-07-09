
require "rails_helper"

require "nokogiri"

require 'templet/layouts/html_rails'

RSpec.describe Templet::Layouts::HtmlRails, type: :helper do
  let(:layout) { Templet::Layouts::HtmlRails.new helper }

  def render_layout(title: 'Mister', description: 'Nice', content: 'Guy')
    layout.(title, description) { content }
  end

  def parse(html)
    Nokogiri::HTML(html)
  end

  def parse_html(selector, single_return: true, html: render_layout)
    method = single_return ? :at_css : :css

    parse(html).send(method, selector)
  end

  it "includes viewport" do
    content = parse_html('head meta[name=viewport]')['content']

    expect(content).to match %r(width=.+initial-scale=)
  end

  describe 'Rails assets' do
    it 'includes stylesheets' do
      href = parse_html('head link[rel=stylesheet]')['href']

      expect(href).to match %r(^/assets/application-.+\.css$)
    end

    it 'includes javascript' do
      src = parse_html('head script')['src']

      expect(src).to match %r(^/assets/application-.+\.js$)
    end
  end

  describe "page params" do
    it "includes title" do
      title = parse_html('head title').text

      expect(title).to eq("Mister")
    end

    it "includes description" do
      description = parse_html('head meta[name=description]')['content']

      expect(description).to eq("Nice")
    end
  end

  it "includes body" do
    body = parse_html('html body').text

    expect(body).to eq("Guy")
  end
end
