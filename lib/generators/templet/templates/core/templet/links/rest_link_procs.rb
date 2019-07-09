
module Templet
  module Links
    # For rendering REST links for any type of model.
    # The methods return lambdas that take as parameters a model
    # and its (optional) parent.
    # These lambdas are also given a Renderer instance,
    # with which they call the Rails helper method +link_to+, as used in views.
    class RestLinkProcs
      include RestLinkProcsSets
      include RestLinkProcsParent

      attr_accessor :link_class, :scope, :controller,
                    :remote, :link_text, :default_params,
                    :verify_path

      def initialize(link_class=nil, remote: nil,
                                     scope: nil,
                                     controller: nil,
                                     default_params: nil,
                                     link_text: nil,
                                     verify_path: false)
        self.link_class = BsBtnClass.(link_class)

        self.remote = remote

        self.scope = scope

        self.controller = controller

        self.default_params = default_params

        self.link_text ||= RestLinkText.new

        self.verify_path = verify_path
      end

      def index_link(text=nil, name: nil, params: nil, title: nil)
        -> renderer, model, parent {
          parent, model = model, name if name

          text ||= link_text.index(model)

          link_to(renderer, :index, model, parent, text, params, title)
        }
      end

      def show_link(text=nil, params: nil, title: nil)
        -> renderer, model, parent {
          text ||= link_text.show(model)

          link_to(renderer, :show, model, parent, text, params, title)
        }
      end

      def new_link(text=nil, name: nil, params: nil, title: nil)
        -> renderer, model, parent {
          parent, model = model, name if name

          text ||= link_text.new(model)

          link_to(renderer, :new, model, parent, text, params, title)
        }
      end

      def edit_link(text=nil, params: nil, title: nil)
        -> renderer, model, parent {
          text ||= link_text.edit(model)

          link_to(renderer, :edit, model, parent, text, params, title)
        }
      end

      def delete_link(text=nil, params: nil, title: nil)
        -> renderer, model, parent {
          text ||= link_text.delete(model)

          link_to(renderer, :delete, model, parent, text,
                  params, title, delete_options)
        }
      end

      alias destroy_link delete_link

      # For additional REST controller links
      def link_by_action(name, params: nil, text: nil, title: nil,
                               on_collection: false, opts: {})
        text ||= name.to_s.capitalize

        -> renderer, model, parent {
          path = rest_path(model, parent)
                   .action(name, params: parameters(params),
                                 on_collection: on_collection)

          title ||= link_text.default_title(name, model)

          link_options = link_to_options title

          renderer.call { link_to text, path, link_options.merge(opts) }
        }
      end

      # For arbitrary explicitly given links - REST or otherwise
      def link_by_path(path, text=nil, title=nil, opts={})
        -> renderer, model, parent {
          link_options = link_to_options title

          path = path.(renderer, model, parent) if path.respond_to? :call

          text ||= link_text.by_path(path)

          renderer.call { link_to text, path, link_options.merge(opts) }
        }
      end

      private

      def link_to(renderer, action, model, parent, text, params, title, opts={})
        path = rest_path(model, parent).send(action, parameters(params))

        return if verify_path and not path_exists?(renderer, path)

        title ||= link_text.default_title(action, model)

        link_options = link_to_options title

        renderer.call { link_to text, path, link_options.merge(opts) }
      end

      def path_exists?(renderer, path)
        !! renderer.url_for(path) rescue false
      end

      def delete_options
        { method: :delete, data: confirm }
      end
      def confirm
        { confirm: 'Delete this record?' }
      end

      def parameters(params)
        if default_params
           default_params.merge(params || {})
        else
          params
        end
      end

      def link_to_options(title)
        opts = link_class ? { class: link_class.to_s, role: 'button' } : {}

        opts[:remote] = true if remote

        opts.merge title: title || ''
      end

      def rest_path(model, parent=nil)
        RestPath.new(model, parent, scope: scope, controller: controller)
      end
    end
  end
end

