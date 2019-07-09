
require "rails_helper"

require 'templet/links'

RSpec.describe Templet::Links::RestLinkProcs, type: :helper do
  include PartialTestHelpers

  include RestLinkProcsHelpers
  include RestLinkProcsAssignments

  describe 'link path' do
    describe '#index' do
      describe 'unnamed' do
        it 'has path with model' do
          _, path = execute(link_procs.index_link, model, nil)

          expect([model_plural]).to eq path
          expect(path).to eq [model_plural]
        end

        it 'has path with model and parent' do
          _, path = execute(link_procs.index_link, model, parent)

          expect(path).to eq [parent, model_plural]
        end
      end

      describe 'named' do
        it 'has path with no model' do
          _, path = execute(link_procs.index_link(name: :dropper), nil, nil)

          expect(path).to eq %i(droppers)
        end

        it 'has path with model' do
          _, path = execute(link_procs.index_link(name: :dropper), model, nil)

          expect(path).to eq [model, :droppers]
        end

        it 'has path with model and parent' do
          _, path = execute(link_procs.index_link(name: :dropper), model, parent)

          expect(path).to eq [model, :droppers]
        end
      end
    end

    describe '#show' do
      it 'has path with model' do
        _, path = execute(link_procs.show_link, model, nil)

        expect(path).to eq single_path
      end

      it 'has path with model and parent' do
        _, path = execute(link_procs.show_link, model, parent)

        expect(path).to eq dual_path
      end
    end

    describe '#new' do
      describe 'unnamed' do
        it 'has path with model' do
          _, path = execute(link_procs.new_link, model, nil)

          expect(path).to eq [:new, model_singular]
        end

        it 'has path with model and parent' do
          _, path = execute(link_procs.new_link, model, parent)

          expect(path).to eq [:new, parent, model_singular]
        end
      end

      describe 'named' do
        it 'has path with no model' do
          _, path = execute(link_procs.new_link(name: :dropper), nil, nil)

          expect(path).to eq %i(new dropper)
        end

        it 'has path with model' do
          _, path = execute(link_procs.new_link(name: :dropper), model, nil)

          expect(path).to eq [:new, model, :dropper]
        end

        it 'has path with model and parent' do
          _, path = execute(link_procs.new_link(name: :dropper), model, parent)

          expect(path).to eq [:new, model, :dropper]
        end
      end
    end

    describe '#edit' do
      it 'has path with model' do
        _, path = execute(link_procs.edit_link, model, nil)

        expect(path).to eq %i(edit) + single_path
      end

      it 'has path with model and parent' do
        _, path = execute(link_procs.edit_link, model, parent)

        expect(path).to eq %i(edit) + dual_path
      end
    end

    describe '#delete' do
      it 'has path with model' do
        _, path = execute(link_procs.delete_link, model, nil)

        expect(path).to eq single_path
      end

      it 'has path with model and parent' do
        _, path = execute(link_procs.delete_link, model, parent)

        expect(path).to eq dual_path
      end

      it 'uses delete method' do
        link, _ = execute(link_procs.delete_link, model, parent)

        expect(link[2][:method]).to eq :delete
      end

      it 'has confirm data' do
        link, _ = execute(link_procs.delete_link, model, parent)

        expect(link[2][:data][:confirm]).to match /Delete/
      end
    end
  end
end
