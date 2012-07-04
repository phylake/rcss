module Compass
  # Implementation of float:left with fix for the
  # [double_margin bug in IE5/6](http://www.positioniseverything.net/explorer/doubled_margin.html)
  def float_left
    float('left')
  end

  # Implementation of float:right with fix for the
  # [double_margin bug in IE5/6](http://www.positioniseverything.net/explorer/doubled_margin.html)
  def float_right
    float('right')
  end

  # Direction independent float mixin that fixes the
  # [double_margin bug in IE5/6](http://www.positioniseverything.net/explorer/doubled_margin.html)
  def float(side='left')
    mixin({
      # display: 'inline',
      float: unquote(side)
    })
  end

  # Resets floated elements back to their default of `float: none` and defaults
  # to `display: block` unless you pass `inline` as an argument
  #
  # Usage Example:
  #
  #     body.homepage
  #       #footer li
  #         +float_left
  #     body.signup
  #       #footer li
  #         +reset_float
  def reset_float(display='block')
    mixin({
      float: 'none',
      display: display
    })
  end
end
