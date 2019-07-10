
module ModelParentHelpers
  def self.included(base)
    base.class_eval do
      # TODO: change!
      let(:scope) { nil }

      # TODO: change!
      let(:new_model) { build :answer }

      # TODO: change!
      let(:model) { create :answer }

      # TODO: change!
      let(:parent) { model.question }

      # TODO: change!
      let(:grand_parent) { parent.category }

      # The following can be left alone

      let(:model_plural) { model.model_name.plural }

      let(:parent_plural) { parent.model_name.plural }

      let(:grand_parent_singular) { grand_parent.model_name.singular }

      let(:grand_parent_plural) { grand_parent.model_name.plural }
    end
  end

  def path_re(prefix: '', suffix: '', parent: parent_plural, model: model_plural)
    %r(^#{prefix}#{scope and '/' + scope}/#{parent}/\d+/#{model}#{suffix}$)
  end
end

