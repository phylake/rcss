require './global'

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
      @gs    = {}# globals
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
      if meth =~ /^g_/
        if meth =~ /=$/
          @gs[meth] = args.first
          return
        end
        
        return @gs[(meth.to_s + '=').to_sym]
      end

      k    = meth.to_s.gsub(/_/, '-')
      v    = args.join(' ')
      h    = {}
      h[k] = v
      mixin h
    end

    def mixin(value)
      @stack.last.merge!(value)
      value
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

def file(name)
  buf = ''
  File.open(name, 'r') {|f| buf = f.read }
  puts RubyCss.to_css_simple RubyCss::Dsl.evaluate(buf).raw
end

def local
  d = RubyCss::Dsl.new

  # d._ ['foo'] {
  # }
  
  puts RubyCss.to_css_simple d.raw
  # puts d.raw
end

# file 'examples/sample.rb'
# local

puts 2.em
puts 100.percent
puts 2.em * 100.percent
puts 100.percent * 2.em
