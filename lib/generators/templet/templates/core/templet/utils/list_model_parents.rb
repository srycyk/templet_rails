
module Templet
  module Utils
    # To list info on a model's parents, and optionally in HTML.
    class ListModelParents
      def call(model, parent_names, out=[])
        if model
          if parent_name = parent_names&.shift
            parent = model.send(parent_name)

            call(parent, parent_names, out)
          end

          out << [ model.model_name.to_s, model.to_s ]
        end

        out
      end

      def in_html(*args)
        call(*args).map do |(name, value)|
          "<b>#{name}</b>: <em class='small'>#{value[0, 25]}</em>"
        end
      end
    end
  end
end
