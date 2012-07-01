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
        k.each {|s| to_css_simple(v, parents.dup << s, str) }
      elsif k.is_a?(Symbol) || k.is_a?(String)
        subs << "\n   #{k.to_s.gsub(/_/, '-')}: #{v.to_s};"
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

  d.g_total_cols = 12
  d.g_col_width = 4.em
  d.g_gutter_width = 1.em
  d.g_side_gutter_width = d.g_gutter_width
  d.g_from_direction = 'left'
  d.g_omega_float = d.opposite_position(d.g_from_direction)

  d._ ['.footer'] {
    d.full
    d.pad(3,3)
  }

  # footer {
  #   clear: both;
  #   margin-left: 1.639%;
  #   margin-right: 1.639%;
  #   padding-left: 24.59%;
  #   padding-right: 24.59%;
  # }
  
  puts RubyCss.to_css_simple d.raw
  # puts d.raw
end

# file 'examples/sample.rb'
local
