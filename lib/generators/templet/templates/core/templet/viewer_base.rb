
module Templet
  # An abstract superclass, either of *ViewerRest*
  # Or of your own custom class if you're not using a REST-based interface
  class ViewerBase
    include Mixins

    attr_accessor :contexts, :locals

    attr_accessor :action, :wrapper

    def initialize(contexts, *, **locals)
      self.contexts = [ contexts ].flatten

      self.locals = locals

      self.wrapper = locals[:wrapper] || :layout
    end

    private

    # Layout and panel

    # Called within a method that adds or overrides an action
    def wrap_action(action=nil)
      self.action = (action || caller_locations(1, 1)[0].label).to_sym

      wrap_around {|renderer| yield renderer }
    end

    # For rendering e.g. JS - use a layout or a panel or have nothing surrounding
    def wrap_around(&block)
      case wrapper
      when :none, :inner
        new_renderer.call {|renderer| yield renderer }
      when :panel, :outer
        panel(new_renderer, &block)
      else
        layout(&block)
      end
    end

    # The layout surrounds everything
    def layout(action=nil, &block)
      self.action ||= action

      layout_class.new(*contexts, **locals).call(*layout_args) do |renderer|
        panel renderer, &block
      end
    end

    # A panel is a sub-layout within the main layout (just above)
    def panel(renderer)
      panel_class.new(renderer).(*panel_args(renderer)) do |renderer|
        yield renderer
      end
    end

    def new_renderer
      Templet::Renderer.new(*contexts, **locals)
    end

    # Used chiefly in menus to check if a link is active
    def action?(current_action)
      current_action.to_sym == action.to_sym
    end

    # Defaults - for overriding

    def layout_class
      Layouts::HtmlRails
    end

    def layout_args
      return page_title, ''
    end

    def page_title
      Rails.app_class.name.split(/::/).first.titlecase
    end

    def panel_class
      Templet::Component::Partial
    end

    def panel_args(renderer)
      return action, panel_options(renderer)
    end

    def panel_options(renderer=nil, **options)
      options.reverse_merge panel_options_default
    end

    def panel_options_default
      { title: panel_title, subtitle: panel_subtitle }
    end

    def panel_subtitle
      action.to_s.capitalize
    end

    def panel_title
      if controller
        controller.to_s
      else
        self.class.name.sub('Viewer', '').split(/::/).last
      end.titleize
    end
  end
end

