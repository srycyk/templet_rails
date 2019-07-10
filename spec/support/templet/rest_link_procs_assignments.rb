
require 'active_support/concern'

module RestLinkProcsAssignments
  extend ActiveSupport::Concern

  included do
    #let(:renderer) { Templet::Renderer.new(self) }
    let :renderer do
      Class.new do
        def call(&block)
          instance_eval &block
        end

        def link_to(*args)
          args
        end
      end.new
    end

    let(:child) { build :answer }
    let(:model) { child.question }
    let(:parent) { model.category }

    let(:model_singular) { model.model_name.singular.to_sym }
    let(:model_plural) { model.model_name.plural.to_sym }

    let(:parent_plural) { parent.model_name.plural.to_sym }
    let(:parent_singular) { parent.model_name.singular.to_sym }

    let (:single_path) { [ model ] }
    let (:dual_path) { [ parent, model ] }

    let(:param) { { q: 'jumper' } }

    let(:default_param) { { token: 'book' } }

    let(:param_options) { { default_params: default_param } }

    let(:remote_options) { { remote: true } }
  end
end

