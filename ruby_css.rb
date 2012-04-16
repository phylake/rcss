class Fixnum
  def to_color
    color = to_s(16)
    color.slice!(1..3) if color.slice(1..3) == color.slice(3..6)
    "##{color}"
  end
  alias_method :color, :to_color
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
      @ks = []# hashes
      @hs = []# keys
      @r  = {}# root hash
    end

    def _(as, &blk)
      return unless as.is_a?(Array) && blk.is_a?(Proc)

      h = @hs.last ? @hs.last[@ks.last] : {}
      h[as] = {}

      @ks << as
      @hs << h

      blk.call

      @ks.pop
      @hs.pop

      @r.merge!(h) if @ks.empty?

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

      h = @hs.last
      k = @ks.last
      h[k].merge!(value)

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
      elsif (k.is_a?(Symbol) || k.is_a?(String)) && v.is_a?(String)
        subs << "\n   #{k.to_s.gsub(/_/, '-')}: #{v};"
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

  def self.to_css(h)

  end
end# RubyCss
