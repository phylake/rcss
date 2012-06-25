# 
# Units
# 
class Unit
  def initialize(value=nil)
    @num = value || 0
  end

  def method_missing(meth, *args, &blk)
    # puts "Unit #{meth}"
    @num.send(meth,*args,&blk)
  end

  def to_s(radix=10)
    @num.to_s(radix)
  end

  def +(value)
    self.class.new(@num + value)
  end

  def -(value)
    self.class.new(@num - value)
  end

  def *(value)
    value.class.new(@num * value)
  end

  def /(value)
    value.class.new(@num / value)
  end
end

class Em < Unit
  def to_s
    "#{@num}em"
  end
end

class Px < Unit
  def to_s
    "#{@num}px"
  end
end

class Pt < Unit
  def to_s
    "#{@num}pt"
  end
end

class Percent < Unit
  def initialize(value=nil)
    @num = super/100.0
  end

  def to_s
    "#{@num*100.0}%"
  end
end

module Conversions
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

# 
# Ruby ext
#
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
