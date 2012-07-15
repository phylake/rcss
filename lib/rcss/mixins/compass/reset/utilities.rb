module Compass
  # Based on [Eric Meyer's reset 2.0](http://meyerweb.com/eric/tools/css/reset/index.html)
  # Global reset rules.
  # For more specific resets, use the reset mixins provided below
  def global_reset
    all = %w(
      a
      abbr
      acronym
      address
      applet
      article
      aside
      audio
      b
      big
      blockquote
      body
      canvas
      caption
      center
      cite
      code
      dd
      del
      details
      dfn
      div
      dl
      dt
      em
      embed
      fieldset
      figcaption
      figure
      footer
      form
      h1
      h2
      h3
      h4
      h5
      h6
      header
      hgroup
      html
      i
      iframe
      img
      ins
      kbd
      label
      legend
      li
      mark
      menu
      nav
      object
      ol
      output
      p
      pre
      q
      ruby
      s
      samp
      section
      small
      span
      strike
      strong
      sub
      summary
      sup
      table
      tbody
      td
      tfoot
      th
      thead
      time
      tr
      tt
      u
      ul
      var
      video
    )

    _(all) {
      reset_box_model
      reset_font
    }
    _ ['body'] {
      reset_body
    }
    _ ['ol', 'ul'] {
      reset_list_style
    }
    _ ['table'] {
      reset_table
    }
    _ ['caption', 'th', 'td'] {
      reset_table_cell
    }
    _ ['q', 'blockquote'] {
      reset_quotation
    }
    _ ['a'] {
      _ ['img'] {
        reset_image_anchor_border
      }
    }

    reset_html5
    nil
  end

  # Reset all elements within some selector scope. To reset the selector itself,
  # mixin the appropriate reset mixin for that element type as well. This could be
  # useful if you want to style a part of your page in a dramatically different way.
  def nested_reset
    all = %w(
      a
      abbr
      acronym
      address
      applet
      article
      aside
      audio
      b
      big
      blockquote
      canvas
      caption
      center
      cite
      code
      dd
      del
      details
      dfn
      div
      dl
      dt
      em
      embed
      fieldset
      figcaption
      figure
      footer
      form
      h1
      h2
      h3
      h4
      h5
      h6
      header
      hgroup
      i
      iframe
      img
      ins
      kbd
      label
      legend
      li
      mark
      menu
      nav
      object
      ol
      output
      p
      pre
      q
      ruby
      s
      samp
      section
      small
      span
      strike
      strong
      sub
      summary
      sup
      table
      tbody
      td
      tfoot
      th
      thead
      time
      tr
      tt
      u
      ul
      var
      video
    )

    _(all) {
      reset_box_model
      reset_font
    }
    _ ['table'] {
      reset_table
    }
    _ ['caption', 'th', 'td'] {
      reset_table_cell
    }
    _ ['q', 'blockquote'] {
      reset_quotation
    }
    _ ['a'] {
      _ ['img'] {
        reset_image_anchor_border
      }
    }

    nil
  end

  # Reset the box model measurements.
  def reset_box_model
    mixin({
      margin:  0,
      padding: 0,
      border:  0
    })
  end

  # Reset the font and vertical alignment.
  def reset_font
    mixin({
      font_size:      '100%',
      font:           'inherit',
      vertical_align: 'baseline'
    })
  end

  # Resets the outline when focus.
  # For accessibility you need to apply some styling in its place.
  def reset_focus
    mixin({
      outline: 0
    })
  end

  # Reset a body element.
  def reset_body
    mixin({
      line_height: 1
    })
  end

  # Reset the list style of an element.
  def reset_list_style
    mixin({
      list_style: 'none'
    })
  end

  # Reset a table
  def reset_table
    mixin({
      border_collapse: 'collapse',
      border_spacing: 0
    })
  end

  # Reset a table cell (`th`, `td`)
  def reset_table_cell
    mixin({
      text_align: 'left',
      font_weight: 'normal',
      vertical_align: 'middle'
    })
  end

  # Reset a quotation (`q`, `blockquote`)
  def reset_quotation
    # _ %w(q:before q:after blockquote:before blockquote:after) {
    #   content '""'
    #   content 'none'
    # }
    mixin({
      quotes: 'none'
      # ,
      # &:before, &:after
      #   content: '""',
      #   content: 'none'
    })
  end

  # Resets the border.
  def reset_image_anchor_border
    mixin({
      border: 'none'
    })
  end

  # Unrecognized elements are displayed inline.
  # This reset provides a basic reset for block html5 elements
  # so they are rendered correctly in browsers that don't recognize them
  # and reset in browsers that have default styles for them.
  def reset_html5
    #{elements_of_type(html5_block)} {
      # display: block; }
    {}
  end

  # Resets the display of inline and block elements to their default display
  # according to their tag type. Elements that have a default display that varies across
  # versions of html or browser are not handled here, but this covers the 90% use case.
  # Usage Example:
  #
  #     // Turn off the display for both of these classes
  #     .unregistered_only, .registered_only
  #       display: none
  #     // Now turn only one of them back on depending on some other context.
  #     body.registered
  #       +reset_display(".registered_only")
  #     body.unregistered
  #       +reset_display(".unregistered_only")
  def reset_display(selector='', important=false)
    #{append_selector(elements_of_type("inline"), $selector)} {
    #  @if $important {
    #    display: inline !important; }
    #  @else {
    #    display: inline; } }
    #{append_selector(elements_of_type("block"), $selector)} {
    #  @if $important {
    #    display: block !important; }
    #  @else {
    #    display: block; } }
    {}
  end
end
