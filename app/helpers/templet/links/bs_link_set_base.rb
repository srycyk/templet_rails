
module Templet
  module Links
    # Superclass with utility methods for building a list (Array) of HTML links.
    # Primarily for REST actions, but any kind of link may be specified.
    #
    # Designed to work with any subclass of ActiveRecord.
    class BsLinkSetBase
      include Constants

      attr_accessor :renderer, :model, :parent, :backward, :forward

      attr_accessor :scope, :controller, :remote, :html_class,
                            :selected, :omit_selected,
                            :default_params, :verify_links,
                            :wrapper

      def initialize(renderer, model, parent, backward=nil, forward=nil,
                               scope: nil, controller: nil,
                               remote: nil, html_class: nil,
                               selected: nil, omit_selected: false,
                               default_params: nil,
                               verify_links: false,
                               wrapper: nil)
        self.renderer = renderer

        self.model = model
        self.parent = parent

        self.backward = backward
        self.forward = forward

        self.scope = scope
        self.controller = controller

        self.remote = remote

        self.html_class = BsBtnClass.(html_class)

        self.selected = selected || BS_SELECTED

        self.omit_selected = omit_selected

        self.default_params = default_params

        self.verify_links = verify_links

        self.wrapper = get_wrapper(wrapper)
      end

      private

      def get_wrapper(wrapper)
        if wrapper
          if wrapper.respond_to? :call
            wrapper
          else
            Utils::SelectedWrapper.new(wrapper, selected)
          end
        end
      end

      def push(links, link)
        links << link if links and link
      end

      def rest_link_procs(link_class, remote: remote(), controller: controller())
        RestLinkProcs.new link_class, scope: scope,
                                      controller: controller,
                                      remote: remote,
                                      default_params: default_params,
                                      verify_path: verify_links
      end

      def link_procs(is_selected=false)
        is_selected ? selected_link_procs : unselected_link_procs
      end

      def unselected_link_procs
        @unselected_link_procs ||= rest_link_procs(html_class)
      end

      def selected_link_procs
        @selected_link_procs ||= rest_link_procs(selected_class)
      end

      def selected_class
        html_class + "#{selected.start_with?(' ') ? '' : ' '}#{selected}"
      end

      def link_proc(action, is_selected=false)
        link_method = "#{action}_link"

        if wrapper
          link = link_procs.send(link_method).(renderer, model, parent)

          wrapper.(link, is_selected)
        else
          link_procs(is_selected).send(link_method).(renderer, model, parent)
        end
      end

      def link_proc_unless(action, current_action, to: nil)
        is_selected = selected? current_action, action

        if display?(is_selected)
          link_proc(action, is_selected).tap {|link| push to, link }
        end
      end

      def link_proc_by_path_selected(action, current_action, *args)
        is_selected = selected? current_action, action

        if display?(is_selected)
          if wrapper
            link = link_procs.link_by_path(*args).(renderer, model, parent)

            wrapper.(link, is_selected)
          else
            link_procs(is_selected).link_by_path(*args)
                                   .(renderer, model, parent)
          end
        end
      end

      def link_proc_by_action_selected(action, current_action, *args)
        is_selected = selected? current_action, action

        if display?(is_selected)
          if wrapper
            link = link_procs.link_by_action(action, *args)
                             .(renderer, model, parent)

            wrapper.(link, is_selected)
          else
            link_procs(is_selected).link_by_action(action, *args)
                                   .(renderer, model, parent)
          end
        end
      end

      def parent_link_proc(action)
        link = rest_link_procs(html_class, controller: nil)
                 .send("#{action}_parent_link", **grand_parent_options)
                 .(renderer, nil, parent)

        wrapper ? wrapper.(link) : link
      end

      def grand_parent_options
        { grand_parent: backward }
      end

      def selected?(current_action, action)
        current_action.to_s == action.to_s
      end

      def display?(is_selected)
        not (omit_selected and is_selected)
      end

      def rest_path(scope: scope(), controller: controller())
        RestPath.new(model, parent, scope: scope, controller: controller)
      end
    end
  end
end

