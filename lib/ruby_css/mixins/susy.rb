module RubyCss
  module Susy
    self.extend RubyCss::Helpers

    # Imports -------------------------------------------------------------------
    require 'ruby_css/mixins/compass/utilities/general/clearfix'
    require 'ruby_css/mixins/compass/utilities/general/float'
    # require './mixins/compass/layout/grid_background'

    # Variables -----------------------------------------------------------------

    # Your basic settings for the grid.
    # g_total_cols = 12
    # g_col_width = 4.em
    # g_gutter_width = 1.em
    # g_side_gutter_width = g_gutter_width

    # Controls for right-to-left or bi-directional sites.
    # g_from_direction = 'left'

    # The direction that +omega elements are floated by deafult.
    # g_omega_float = opposite_position(g_from_direction)

    # Functions -----------------------------------------------------------------

    # Return the width of 'n' columns plus 'n - 1' gutters
    # plus page padding in non-nested contexts
    def column_width(n=0)
      sg = 0
      if n.zero?
        n = g_total_cols
        sg = g_side_gutter_width
      end
      (n*g_col_width) + ((n - 1)*g_gutter_width).ceil + (sg*2)
    end

    # Return the percentage for the target in a given context
    def percent_width(t, c)
      # Both of these work
      # (t.u / c) * 100.percent
      # ((t / c.to_f) * 100).percent
      # TODO make this work
      # (t / c) * 100.percent

      (t.u / c) * 100.percent
    end

    # Return the percentage width of 'n' columns in a context of 'c'
    def column_percent(n, c=0)
      percent_width(column_width(n), column_width(c))
    end

    # Return the percentage width of a single gutter in a context of 'c'
    def gutter(c=0)
      percent_width(g_gutter_width, column_width(c))
    end

    # Return the percentage width of a single side gutter in a context of 'c'
    def side_gutter(c=0)
      percent_width(g_side_gutter_width, column_width(c))
    end

    # Return the percentage width of a single column in a context of 'c'
    def column(c=0)
      percent_width(g_col_width, column_width(c))
    end

    # Base Mixin ----------------------------------------------------------------

    # Set the outer grid-containing element(s).
    def container
      # TODO before/after filters
      # pie_clearfix
      
      mixin({
        margin: 'auto',
        width: column_width.em,
        max_width: 100.percent
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
    def columns(n, context=0, from=g_from_direction)
      to = opposite_position(from)

      # the column is floated left
      float(from)
      
      mixin({
        # the width of the column is set as a percentage of the context
        width: column_percent(n, context),
        # the right gutter is added as a percentage of the context
        "margin_#{to}" => gutter(context)
      })
    end

    # reset a column element to default block behavior
    def reset_column(from=g_from_direction)
      to = opposite_position(from)
      reset_float
      mixin({
        width: 'auto',
        "margin-#{to}" => auto
      })
    end

    def un_column(from=g_from_direction)
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
    def prefix(n, context=0, from=g_from_direction)
      mixin({
        "padding-#{from}" => column_percent(n, context) + gutter(context)
      })
    end

    # add empty colums as padding after an element.
    def suffix(n, context=0, from=g_from_direction)
      to = opposite_position(from)
      mixin({
        "padding-#{to}" => column_percent(n, context) + gutter(context)
      })
    end

    # add empty colums as padding before and after an element.
    def pad(p=0, s=0, c=0, from=g_from_direction)
      prefix(p, c, from) unless p.zero?
      suffix(s, c, from) unless s.zero?
    end

    # Alpha & Omega Mixins ------------------------------------------------------
    # I recommend that you pass the actual nested contexts (when nested) rather
    # than a true/false argument for the sake of consistency. Effect is the same,
    # but your code will be much more readable.

    # mixin on any element spanning the first column in non-nested context to
    # take side-gutters into account.
    def alpha(nested=false, from=g_from_direction)
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
    def omega(nested=false, from=g_from_direction)
      to   = opposite_position(from)
      hack = opposite_position(g_omega_float)
      sg   = nested ? 0 : side_gutter
      float(g_omega_float)

      m = {
        "margin-#{to}" => sg
      }
      m["margin-#{hack}"] = g_gutter_width if legacy_support_for_ie6 or legacy_support_for_ie7
      mixin m
    end

    # Susy Grid Backgrounds -----------------------------------------------------

    # def susy_grid_background
    #   column_grid_background(g_total_cols, g_col_width, g_gutter_width, g_side_gutter_width, true)
    # end

    # def show_grid(img=false)
    #   warn "show_grid is deprecated in favor of susy_grid_background."
    #   warn "show_grid and susy_grid_background no longer use any images or take any arguments." if img
    #   susy_grid_background
    # end

  end

  Dsl.send(:include, Susy)
end
