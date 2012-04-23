class Unit
  @num

  def initialize(value=nil)
    @num = value
  end

  def method_missing(meth, *args, &blk)
    puts meth
    @num.send(meth,*args,&blk)
  end

  def to_s(radix=10)
    @num.to_s(radix)
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
  def to_s
    "#{@num}%"
  end
end

class Fixnum
  def to_color
    color = to_s(16)
    color.slice!(1..3) if color.slice(1..3) == color.slice(3..6)
    "##{color}"
  end
  alias_method :color, :to_color

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

class Float
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

class String
  def from_color(value)
  end
  alias_method :color, :from_color
end
