
module Templet
  module Links
    # For the text and title on buttons and links
    class RestLinkText
      def index(model)
        model_plural(model)
      end

      def show(model)
        'Show'
      end

      def new(model)
        'New ' + model_singular(model)
      end

      def edit(model)
        'Edit'
      end

      def delete(model)
        'Delete'
      end

      def by_path(path)
        String === path ? path.tr('/', ' ').strip.capitalize : 'Go'
      end

      def default_title(action, model)
        case action
        when :index
          title_plural(action, model)
        when :new
          title_singular(action, model)
        when :show, :edit, :delete
          title_info(action, model)
        else
          title_plural(action, model)
        end
      end

      def parent_text(action, parent)
        if action == :index
          prefix, suffix = parent.model_name.plural
        else
          prefix, suffix = action, parent.model_name.singular
        end

        "#{prefix.to_s.capitalize} #{suffix}"
      end

      def title_singular(action, model)
        title action, model_singular(model)
      end

      def title_plural(action, model)
        title action, model_plural(model)
      end

      def title_info(action, model)
        title action, model_info(model)
      end

      def title(action, model_text)
        "#{action_alias action} #{model_text}"
      end

      private

      def model_plural(model)
        if model.respond_to?(:model_name)
          model.model_name.plural
        else
          model.to_s.pluralize
        end.capitalize.tr('_', ' ')
      end

      def model_singular(model)
        if model.respond_to?(:model_name)
          model.model_name.singular
        else
          model.to_s
        end
      end

      def model_info(model)
        "#{model.model_name.singular}: #{model}"
      end

      def action_alias(action)
        { index: 'List',
          show: 'See',
          new: 'Create',
          edit: 'Update',
          delete: 'Remove',
        }[action] || action.to_s.capitalize
      end
    end
  end
end

