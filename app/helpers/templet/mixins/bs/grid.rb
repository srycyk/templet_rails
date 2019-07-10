
module Templet
  module Mixins
    module Bs
      # For the Bootstrap grid system
      module Grid
        include Constants

        # For arranging a row into columns. Divided into twelfths.
        # +columns+ is a Hash. For example: { 2 => menu, 10 => table }
        def in_cols(renderer, columns)
          inner_self = self

          renderer.call do
            div :row do
              columns.to_h.reduce [] do |acc, (count, content)|
                acc << div(inner_self.col_class count) { content }
              end
            end
          end
        end

        # For arranging content into stacked rows.
        # +rows+ is an Array of separate elements, e.g. [ menu, table ]
        def in_rows(renderer, *rows, cols: nil, offset: nil)
          rows += yield(renderer) if block_given?

          inner_self = self

          renderer.call do
            rows.flatten.compact.map do |row|
              div :row do
                html_class = inner_self.col_offset_class(offset) +
                             inner_self.col_class(cols)

                div(html_class) { row }
              end
            end
          end
        end

        def col_class(cols=nil)
          "#{BS_COL}#{cols || 12} "
        end

        def col_offset_class(offset)
          offset ? "#{BS_COL_OFFSET}#{offset} " : ''
        end
      end
    end
  end
end

