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

  Dsl.send(:include, Color)
end# RubyCss
