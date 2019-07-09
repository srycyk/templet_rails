
require "rails_helper"

require 'templet/links'

RSpec.describe Templet::Links::BsLinkSetCollection, type: :helper do
  include PartialTestHelpers

  include ModelParentHelpers

  def scoped_partial(*args, **options)
    partial(*args, **options.merge(scope: scope)).call
  end

  describe 'link count' do
    it "has two without parent" do
      links = scoped_partial(grand_parent, nil)

      expect(links.size).to eq 2
    end

    it "has three with parent" do
      links = scoped_partial(model, parent, grand_parent_singular)

      expect(links.size).to eq 3
    end
  end

  describe 'parent link' do
    it "has href to grand_parent index" do
      links = scoped_partial(parent, grand_parent)

      re = %r(href="#{scope and '/' + scope}/#{grand_parent_plural}")

      expect(links.first).to match re
    end

    it "has href to parent index" do
      links = scoped_partial(model, parent, grand_parent_plural.singularize)

      re = path_re prefix: '.+href="', suffix: '".+',
                   parent: grand_parent_plural, model: parent_plural

      expect(links.first).to match re
    end
  end

  describe 'index link' do
    it "has href" do
      links = scoped_partial(model, parent, grand_parent_singular)

      re = path_re prefix: '.+href="', suffix: '".+'

      expect(links.second).to match re
    end
  end

  describe 'new link' do
    it "has href" do
      links = scoped_partial(model, parent, grand_parent_singular)

      re = path_re prefix: '.+href="', suffix: '/new".+'

      expect(links.last).to match re
    end
  end

  describe 'param passing' do
    it "has default param" do
      param = { token: 'book' }

      options = { default_params: param }

      links = scoped_partial(model, parent, grand_parent_singular, **options)

      expect(links.first).to match %r(\?token=book)
    end
  end
end
