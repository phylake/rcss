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
    if @num.is_a?(Float)
      @num.to_s
    elsif @num.is_a?(Fixnum)
      @num.to_s(radix)
    else
      raise "@num is not a Float or Fixnum"
    end
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
    num.zero? ? '0' : "#{num}em"
  end
end

class Px < Unit
  def to_s
    num.zero? ? '0' : "#{num}px"
  end
end

class Pt < Unit
  def to_s
    num.zero? ? '0' : "#{num}pt"
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
    "%.3f%" % num
  end
end

######################################
#             Ruby ext
######################################
class Fixnum
  include Conversions

  def to_color
    "#%06X" % self
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
  undef :display
  
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end
