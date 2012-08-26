module Compass
  # This basic method is preferred for the usual case, when positioned
  # content will not show outside the bounds of the container.
  # 
  # Recommendations include using this in conjunction with a width.
  # Credit: [quirksmode.org](http://www.quirksmode.org/blog/archives/2005/03/clearing_floats.html)
  def clearfix
    mixin({
      overflow: 'hidden'
    })
  end

  # This older method from Position Is Everything called
  # [Easy Clearing](http://www.positioniseverything.net/easyclearing.html)
  # has the advantage of allowing positioned elements to hang
  # outside the bounds of the container at the expense of more tricky CSS.
  def legacy_pie_clearfix
    mixin({
      content:    '\0020',
      display:    'block',
      height:     '0',
      clear:      'both',
      overflow:   'hidden',
      visibility: 'hidden'
    })
  end

  # This is an updated version of the PIE clearfix method that reduces the amount of CSS output.
  # If you need to support Firefox before 3.5 you need to use `legacy_pie_clearfix` instead.
  # 
  # Adapted from: [A new micro clearfix hack](http://nicolasgallagher.com/micro_clearfix_hack/)
  def pie_clearfix
    # TODO before/after filters
    mixin({
      content: '""',
      display: 'table',
      clear:   'both'
    })
  end

  # The other main method is to place an empty div after the float to be cleared
  # <div style="clear: both;">
end
