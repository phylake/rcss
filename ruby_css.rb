class Unit
  @num

  def initialize(value=nil)
    @num = value
  end

  def method_missing(meth, *args, &blk)
    @num.send(meth,*args,&blk)
  end

  def to_s(radix=10)
    method_missing('to_s', radix)
  end
end

class Em < Unit
end

class Px < Unit
end

class Pt < Unit
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
end

class String
  def from_color(value)
  end
  alias_method :color, :from_color
end

module RubyCss
  class Dsl
    def self.evaluate(string, instance=nil)
      instance ||= Dsl.new
      instance.instance_eval(string)
      instance.finalize
      instance
    end

    def initialize
      @stack = []# hashes
      @r     = {}# root hash
    end

    def _(as, &blk)
      return unless as.is_a?(Array) && blk.is_a?(Proc)

      h = @stack.last || {}
      @stack << h[as] = {}

      blk.call

      @stack.pop

      @r.merge!(h) if @stack.empty?

      nil
    end
    
    def method_missing(meth, *args, &blk)
      k    = meth.to_s.gsub(/_/, '-')
      v    = args.join(' ')
      h    = {}
      h[k] = v
      mixin h
    end

    def mixin(value)
      return unless value.is_a?(Hash)
      @stack.last.merge!(value)
      nil
    end

    def finalize
    end

    def raw
      @r
    end

  end# Dsl
  
  def self.to_css_simple(h, parents=[], str='')
    parents.uniq!
    
    subs = ''

    h.each do |k,v|
      if k.is_a?(Array) && v.is_a?(Hash)
        k.each {|s| to_css_simple(v, Array.new(parents) << s, str) }
      elsif (k.is_a?(Symbol) || k.is_a?(String))
        if v.is_a?(String)
          subs << "\n   #{k.to_s.gsub(/_/, '-')}: #{v};"
        elsif v.is_a?(Hash)

        end
      else
        raise "invalid key/value pair"
      end
    end

    unless subs.empty?
      str << parents.join(' ')
      str << " {#{subs}\n}\n"
    end

    str
  end

  def self.to_css(h, str='')

  end

  require './mixins/all'
end# RubyCss

def file
  buf = ''
  File.open('examples/sample.rb', 'r') {|f| buf = f.read }
  puts RubyCss.to_css_simple RubyCss::Dsl.evaluate(buf).raw
end

def local
  d = RubyCss::Dsl.new

  d._ ['.list_layout'] {
    d._ ['.list_style'] {
      d._ ['input'] {
        d.width '100%'
        d.margin_bottom '.5em'
      }

      d.padding '1em'
      d.background '#F5F5F5'

      r = 8
      d.border('solid', 1, '#eee', r, r, r, r)
      d.drop_shadow(1, 1, 1, '#fafafa', true)
    }
  }

  puts RubyCss.to_css_simple d.raw
  # puts d.raw
end

# file
local
