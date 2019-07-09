
require "rails_helper"

require 'templet/links'

RSpec.describe Templet::Links::RestLinkProcs, type: :helper do
  include PartialTestHelpers

  include RestLinkProcsHelpers
  include RestLinkProcsAssignments

  describe 'parent link' do
    let (:gp_opts) { { grand_parent: parent_singular } }

    describe '#index' do
      it 'has path of parent' do
        _, path = execute(link_procs.index_parent_link, model, parent)

        expect(path).to eq [parent_plural]
      end

      it 'has path of grand parent' do
       link_proc = link_procs.index_parent_link(**gp_opts)

        _, path = execute(link_proc, child, model)

        expect(path).to eq [parent, model_plural]
      end
    end

    describe '#show' do
      it 'has path of parent' do
        _, path = execute(link_procs.show_parent_link, model, parent)

        expect(path).to eq [parent]
      end

      it 'has path of grand parent' do
        link_proc = link_procs.show_parent_link(**gp_opts)
        _, path = execute(link_proc, child, model)

        expect(path).to eq [parent, model]
      end
    end

    describe '#new' do
      it 'has path of parent' do
        _, path = execute(link_procs.new_parent_link, model, parent)

        expect(path).to eq [:new, parent_singular]
      end

      it 'has path of grand parent' do
       link_proc = link_procs.new_parent_link(**gp_opts)

        _, path = execute(link_proc, child, model)

        expect(path).to eq  [:new, parent, model_singular]
      end
    end

    describe '#edit' do
      it 'has path of parent' do
        _, path = execute(link_procs.edit_parent_link, model, parent)

        expect(path).to eq [:edit, parent]
      end

      it 'has path of grand parent' do
       link_proc = link_procs.edit_parent_link(**gp_opts)

        _, path = execute(link_proc, child, model)

        expect(path).to eq  [:edit, parent, model]
      end
    end
  end
end
