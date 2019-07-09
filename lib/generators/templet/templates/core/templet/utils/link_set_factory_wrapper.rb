
module Templet
  module Utils
    # Creates HTML links for REST actions in Bootstrap containers
    class LinkSetFactoryWrapper < LinkSetFactory
      include Mixins::Bs::Lists

      def call(type=nil, **options)
        stacked = options.delete(:stacked) || false

        wrap type, create(link_set_options(type).merge options), stacked: stacked
      end

      private

      def link_set_options(type)
        case type
        when :pills, :tabs
          { html_class: '', wrapper: nav_li_wrapper }
        when :buttons, :toolbar
          { html_class: %i(default md) }
        when :links
          { html_class: %i(link sm), selected: 'disabled' }
        else
          { html_class: :item }
        end
      end

      def wrap(type, links, stacked: false)
        case type
        when :pills
          in_nav renderer, links.flatten, stacked: stacked
        when :tabs
          in_nav renderer, links.flatten, tabs: true, stacked: stacked
        when :buttons
          in_button_group renderer, links.flatten, stacked: stacked
        when :toolbar
          in_button_toolbar renderer, links, stacked: stacked
        when :links
          in_list_group_links renderer, links.flatten
        else
          in_list_group_buttons renderer, links.flatten
        end
      end

      def nav_li_wrapper
        { regular: '<li role="presentation">%s</li>',
          selected: '<li role="presentation" class="active">%s</li>' }
      end
    end
  end
end

