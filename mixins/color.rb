module RubyCss
  module Color
    def adjust(color, value)
      return -1 unless color.is_a?(Fixnum)
      return color if value.zero?

      if -1 < value && value < 1
        value = value > 0 ? value + 1 : value - 1

        r = (((color >> 16) * value) & 0xff) << 16
        g = (((color >>  8) * value) & 0xff) <<  8
        b = (((color >>  0) * value) & 0xff) <<  0
      else
        r = (((color >> 16) + value) & 0xff) << 16
        g = (((color >>  8) + value) & 0xff) <<  8
        b = (((color >>  0) + value) & 0xff) <<  0
      end
      
      r | g | b
    end
    alias_method :brighten, :adjust

    def darken(color, value)
      adjust(color, -value)
    end

  end# Color

  module Vendor
    VENDORS = {
      0x1 => '',
      0x2 => '-webkit-',
      0x4 => '-moz-'
    }

    NONE   = 0x1
    WEBKIT = 0x2
    MOZ    = 0x4

    def border(style, width=1, color=0, tl=0, tr=0, br=0, bl=0)
      styles = %(
        dashed
        dotted
        double
        groove
        hidden
        inset
        outset
        ridge
        inherit
        none
        solid
      )

      style = styles.last unless styles.include?(style)

      m = {
        border: "#{style} #{width} #{color}"
      }

      m['-webkit-border-top-left-radius']     = "#{tl}px"
      m['-webkit-border-top-right-radius']    = "#{tr}px"
      m['-webkit-border-bottom-right-radius'] = "#{br}px"
      m['-webkit-border-bottom-left-radius']  = "#{bl}px"

      m['-moz-border-radius-topleft']         = "#{tl}px"
      m['-moz-border-radius-topright']        = "#{tr}px"
      m['-moz-border-radius-bottomright']     = "#{br}px"
      m['-moz-border-radius-bottomleft']      = "#{bl}px"
      
      m['border-top-left-radius']             = "#{tl}px"
      m['border-top-right-radius']            = "#{tr}px"
      m['border-bottom-right-radius']         = "#{br}px"
      m['border-bottom-left-radius']          = "#{bl}px"

      mixin m
    end

    def drop_shadow(h, v, blur, color, inset=false)
      m = {}

      VENDORS.each_value do |v|
        m["#{v}box-shadow"] = "#{h}px #{v}px #{blur}px #{color}"
      end

      mixin m
    end
  end# Vendor

  Dsl.send(:include, Color)
  Dsl.send(:include, Vendor)
end# RubyCss
