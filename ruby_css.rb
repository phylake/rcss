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

  require './mixins/basic'
end# RubyCss

module RubyCss
    module Foo
      def foo_bar(value)
        h = {
          ['td'] => {
            color: 0xffffff.color
          },
          ['tr'] => {
            color: 0xffffff.color
          }
        }

        mixin h
      end
    end

    Dsl.send(:include, Foo)
end

# h = {
#   ['div', 'hl'] => {
#     color: '#000',
#     color: '#222',
#     foo_bar: 'ack',
#     ['.nested-class'] => { color: '#fff' },
#     ['hr', 'div', '.other-class'] => { color: '#fff' } # need to solve this
#   }
# }

# i = {
#   ['div'] => {
#     color: '#222'
#   },

#   ['hl'] => {
#     color: '#222'
#   },

#   ['div', '.nested-class'] => {
#     color: '#fff'
#   }
# }

# puts RubyCss.to_css(h)

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

file
# local
