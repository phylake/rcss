module RubyCss
  module Susy

    # Imports -------------------------------------------------------------------

    require './mixins/compass/utilities/general/clearfix'
    require './mixins/compass/utilities/general/float'
    # require './mixins/compass/layout/grid_background'

    # Variables -----------------------------------------------------------------

    # Your basic settings for the grid.
    total_cols = 12
    col_width = 4.em
    gutter_width = 1.em
    side_gutter_width = gutter_width

    # Controls for right-to-left or bi-directional sites.
    from_direction = 'left'

    # The direction that +omega elements are floated by deafult.
    omega_float = opposite_position(from_direction)

    # Functions -----------------------------------------------------------------

    # Return the width of 'n' columns plus 'n - 1' gutters
    # plus page padding in non-nested contexts
    def columns_width(n=0)
      sg = 0
      if n.zero?
        n = total_cols
        sg = side_gutter_width
      end
      (n*col_width) + (ceil(n - 1)*gutter_width) + (sg*2)
    end

    # Return the percentage for the target in a given context
    def percent_width(t, c)
      (t / c) * 100
    end

    # Return the percentage width of 'n' columns in a context of 'c'
    def columns(n, c=0)
      percent_width(columns_width(n), columns_width(c))
    end

    # Return the percentage width of a single gutter in a context of 'c'
    def gutter(c=0)
      percent_width(gutter_width, columns_width(c))
    end

    # Return the percentage width of a single side gutter in a context of 'c'
    def side_gutter(c=0)
      percent_width(side_gutter_width, columns_width(c))
    end

    # Return the percentage width of a single column in a context of 'c'
    def column(c=0)
      percent_width(col_width, columns_width(c))
    end

    # Base Mixin ----------------------------------------------------------------

    # Set the outer grid-containing element(s).
    def container
      pie_clearfix
      mixin({
        margin: 'auto',
        width: columns_width,
        max_width: '100%'
      })
    end

    # Column Mixins -------------------------------------------------------------

    # Set +columns() on any column element, even nested ones.
    # The first agument [required] is the number of columns to span.
    # The second argument is the context (columns spanned by parent).
    #  - Context is required on any nested elements.
    #  - Context MUST NOT be declared on a top-level element.
    # By default a grid_column is floated left with a right gutter.
    #  - Override those with +float("right"), +alpha or +omega
    def columns_m(n, context=0, from=from_direction)
      to = opposite_position(from)

      # the column is floated left
      float(from)
      
      mixin({
        # the width of the column is set as a percentage of the context
        width: columns(n, context),
        # the right gutter is added as a percentage of the context
        "margin_#{to}" => gutter(context)
      })
    end

    # reset a column element to default block behavior
    def reset_column(from=from_direction)
      to = opposite_position(from)
      reset_float
      mixin({
        width: 'auto',
        "margin-#{to}" => auto
      })
    end

    def un_column(from=from_direction)
      reset_column(from)
    end

    # mixin `full` on an element that will span it's entire context.
    # There is no need for +columns, +alpha or +omega on a +full element.
    def full(nested=false)
      m = { clear: 'both' }
      
      m.merge!({
        margin_left: side_gutter,
        margin_right: side_gutter
      }) unless nested
      
      mixin m
    end

    # Padding Mixins ------------------------------------------------------------

    # add empty colums as padding before an element.
    def prefix(n, context=0, from=from_direction)
      mixin({
        "padding-#{from}" => columns(n, context) + gutter(context)
      })
    end

    # add empty colums as padding after an element.
    def suffix(n, context=0, from=from_direction)
      to = opposite_position(from)
      mixin({
        "padding-#{to}" => columns(n, context) + gutter(context)
      })
    end

    # add empty colums as padding before and after an element.
    def pad(p=false, s=false, c=0, from=from_direction)
      prefix(p, c, from) if p
      suffix(s, c, from) if s
    end

    # Alpha & Omega Mixins ------------------------------------------------------
    # I recommend that you pass the actual nested contexts (when nested) rather
    # than a true/false argument for the sake of consistency. Effect is the same,
    # but your code will be much more readable.

    # mixin on any element spanning the first column in non-nested context to
    # take side-gutters into account.
    def alpha(nested=false, from=from_direction)
      m = {}
      if nested
        warn "The alpha mixin is not needed in a nested context"
      else
        m["margin-#{from}"] = side_gutter
      end
      mixin m
    end

    # mixin on the last element of a row, in order to take side_gutters and
    # the page edge into account. Set the nested argument for nested columns.
    def omega(nested=false, from=from_direction)
      to   = opposite_position(from)
      hack = opposite_position(omega_float)
      sg   = nested ? side_gutter : 0
      float(omega_float)

      m = {
        "margin-#{to}" => sg
      }
      m["margin-#{hack}"] = gutter_width if legacy_support_for_ie6 or legacy_support_for_ie7
      mixin m
    end

    # Susy Grid Backgrounds -----------------------------------------------------

    # def susy_grid_background
    #   column_grid_background(total_cols, col_width, gutter_width, side_gutter_width, true)
    # end

    # def show_grid(img=false)
    #   warn "show_grid is deprecated in favor of susy_grid_background."
    #   warn "show_grid and susy_grid_background no longer use any images or take any arguments." if img
    #   susy_grid_background
    # end

  end
  
  Dsl.send(:include, Susy)
end
