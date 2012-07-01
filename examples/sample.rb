#
# Vars
#

# Your basic settings for the grid
self.g_total_cols = 12
self.g_col_width = 4.em
self.g_gutter_width = 1.em
self.g_side_gutter_width = g_gutter_width

# Controls for right-to-left or bi-directional sites.
self.g_from_direction = 'left'

# The direction that +omega elements are floated by deafult.
self.g_omega_float = opposite_position(g_from_direction)

self.g_show_grid_backgrounds = false
self.g_global_fixed_height = (g_gutter_width * 3)

#
# Tags
#

# global_reset

_ ['body'] {
  font_family '"Helvetica Neue"', 'Helvetica', 'Arial', 'sans_serif'
  line_height 1.5
}

_ ['footer'] {
  full
  pad(3,3)
}

_ ['input[type=search]'] {
  font_size 16.px
}

#
# Classes
#

_ ['.susy_container'] {
  container
  # susy_grid_background
}

_ ['.susy_container:after'] {
  pie_clearfix
}

_ ['.list_layout'] {
  columns(3)
  alpha

  _ ['.list_style'] {
    _ ['input'] {
      width 100.percent
      margin_bottom 0.5.em
    }

    padding 1.em
    background 0xF5F5F5.color

    r = 8
    border 'solid', 1, '#eee', r, r, r, r

    drop_shadow 1, 1, 1, '#fafafa', true
  }
}

_ ['.detail_view'] {
  columns(9)
  omega
}

#
# Ids
#

_ ['#global_nav'] {
  # font_size: 1.5em
  # line_height: 3em

  background_color '#333'
  color '#eee'
  position 'fixed'
  top 0
  right 0
  left 0
  min_height g_global_fixed_height
  background '-webkit-gradient(linear, 0% 100%, 0% 0%, from(#222), to(#333))'
  drop_shadow 0, 5, 5
}

_ ['#global_page'] {
  width '100%'
  padding_top(g_global_fixed_height + 0.5)
  margin_top g_gutter_width
}
