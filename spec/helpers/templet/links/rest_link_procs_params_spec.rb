
require "rails_helper"

require 'templet/links'

RSpec.describe Templet::Links::RestLinkProcs, type: :helper do
  include PartialTestHelpers

  include RestLinkProcsHelpers
  include RestLinkProcsAssignments

  def link_method(action)
    "#{action}_link"
  end

  def orphaned(with_parent)
    with_parent ? parent : nil
  end

  describe 'Parameter passing' do
    %w(index show delete).each do |action|
      [ false, true ].each do |with_parent|
        desc = "#{action} parameters with#{with_parent ? '' : :out} parent"

        describe desc do
          it 'passes direct params' do
            link_proc = link_procs.send(link_method(action), params: param)

            _, path = execute(link_proc, model, orphaned(with_parent))

            expect(path.last).to eq param
          end

          it 'uses default params' do
            link_proc = link_procs(param_options).send(link_method(action))

            _, path = execute(link_proc, model, orphaned(with_parent))

            expect(path.last).to eq default_param
          end

          it 'passes direct params and uses default params' do
            link_procs = link_procs(param_options)

            link_proc = link_procs.send(link_method(action), params: param)

            _, path = execute(link_proc, model, orphaned(with_parent))

            expect(path.last).to eq default_param.merge(param)
          end
        end
      end
    end
  end

=begin
  describe 'param passing' do
    it "has param" do

      link = link_proc.index_link(params: param).(renderer, question, category)

      expect(link).to match %r(\?.*q=jumper)

      expect(link).to match %r(\?.*token=book)
    end
  end
=end
end
