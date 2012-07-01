######################################
#               Units
######################################
module Conversions
  def u
    Unit.new(self)
  end

  def em
    Em.new(self)
  end

  def px
    Px.new(self)
  end

  def pt
    Pt.new(self)
  end

  def percent
    Percent.new(self)
  end
end

class Unit
  include Conversions

  def initialize(value=nil)
    @num = value.is_a?(Unit) ? value.num : value
    @num ||= 0
  end

  def method_missing(meth, *args, &blk)
    @num.send(meth,*args,&blk)
  end

  def to_s(radix=10)
    @num.to_s(radix)
  end

  def +(value)
    if value.is_a?(Unit)
      value.class.new(num + value.num)
    else
      self.class.new(num + value)
    end
  end

  def -(value)
    if value.is_a?(Unit)
      value.class.new(num - value.num)
    else
      self.class.new(num - value)
    end
  end

  def *(value)
    if value.is_a?(Unit)
      value.class.new(num * value.num)
    else
      self.class.new(num * value)
    end
  end

  def /(value)
    if value.is_a?(Unit)
      value.class.new(num / value.num.to_f)
    else
      self.class.new(num / value.to_f)
    end
  end

  def num
    @num
  end
end

class Em < Unit
  def to_s
    "#{num}em"
  end
end

class Px < Unit
  def to_s
    "#{num}px"
  end
end

class Pt < Unit
  def to_s
    "#{num}pt"
  end
end

class Percent < Unit
  def initialize(value=nil)
    @num = super/100.0
  end

  def num
    super*100
  end

  def to_s
    # "%d%" % (num + (((num % 1) * 1000).to_i / 1000.0))
    "%.3f%" % num
  end
end

######################################
#             Ruby ext
######################################
class Fixnum
  include Conversions

  def to_color
    color = to_s(16)
    color.slice!(1..3) if color.slice(1..3) == color.slice(3..6)
    "##{color}"
  end
  alias_method :color, :to_color
end

class Float
  include Conversions
end

class String
  def from_color(value)
  end
  alias_method :color, :from_color
end

class Object
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end
