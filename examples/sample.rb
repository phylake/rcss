#
# Imports
#

# @import "compass/reset";
# @import "susy";
# @import "mixins";

#
# Vars
#

total_cols = 12
col_width = 4.em
gutter_width = 1.em
side_gutter_width = gutter_width

show_grid_backgrounds = false
global_fixed_height = gutter_width * 3

#
# Tags
#

_ '[body]' {
  font_family '"Helvetica Neue"', 'Helvetica', 'Arial', 'sans_serif'
  line_height 1.5
}

# nav {
#   columns(3)
#   alpha
# }

_ ['footer'] {
  full
  pad(3,3)
}

_ ['input[type=search]'] {
  font_size 16.px
}

# div[role="main"] {
#   columns(9)
#   omega
#   article {
#     columns(6,9)
#   }
#   aside {
#     columns(3,9)
#     omega(9)
#   }
# }

#
# Classes
#

_ ['.susy_container'] {
  container
  susy_grid_background
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
  min_height global_fixed_height
  background '-webkit_gradient(linear, 0% 100%, 0% 0%, from(#222), to(#333))'
  drop_shadow 0, 5, 5
}

_ ['#global_page'] {
  width '100%'
  padding_top(global_fixed_height + .5)
  margin_top gutter_width
}
