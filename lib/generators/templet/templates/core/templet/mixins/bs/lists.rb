
module Templet
  module Mixins
    module Bs
      # Renders various listing and Bootstrap grouping components
      module Lists
        include Constants

        include HtmlPresenters

        def in_html_list(renderer, items=nil, **opts)
          items = yield(renderer) if block_given?

          html_list(renderer, items, **opts)
        end

        def in_list_group_links(renderer, links)
          in_html_list renderer, links, html_class: BS_LIST_GROUP,
                                        item_class: BS_LIST_GROUP_ITEM
        end

        def in_list_group_buttons(renderer, links)
          renderer.call do
            div(links, BS_LIST_GROUP)
          end
        end

        def in_nav(renderer, links, tabs: false, stacked: false)
          html_class = tabs ? BS_NAV_TABS : BS_NAV_PILLS

          html_class += " #{BS_NAV_PILLS_STACKED}" if stacked

          in_html_list(renderer, links, html_class: html_class)
        end

        def in_button_group(renderer, links, stacked: false, justified: false)
          renderer.call do
            html_class = stacked ? BS_BUTTON_GROUP_VERTICAL : BS_BUTTON_GROUP

            html_class += ' ' + BS_BUTTON_GROUP_JUSTIFIED if justified

            div(links, html_class, role: 'group')
          end
        end

        def in_button_toolbar(renderer, toolbar_links, **options)
          this = self

          renderer.call do
            div BS_BUTTON_TOOLBAR, role: BS_TOOLBAR do
              toolbar_links.map do |links|
                this.in_button_group(renderer, links, **options)
              end
            end
          end
        end

        def button_group_dropdown(renderer, links, text, btn_class='btn-default')
          list = in_html_list(renderer, links, html_class: BS_BUTTON_DROPDOWN)

          atts = { type: "button",
                   class: "btn #{btn_class} dropdown-toggle",
                   data_toggle: "dropdown",
                   aria_haspopup: true,
                   aria_expanded: false }

          caret = " <span class='caret'></span>"

          renderer.call do
            div(:btn_group) { [ button(text + caret, atts), *list ] }
          end
        end
      end
    end
  end
end

