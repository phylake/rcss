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
      return unless value.is_a?(Hash)
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

def local2
  d = RubyCss::Dsl.new

  # Your basic settings for the grid.
  d.g_total_cols = 12
  d.g_col_width = 4.em
  d.g_gutter_width = 1.em
  d.g_side_gutter_width = d.g_gutter_width
  d.g_from_direction = 'left'
  d.g_omega_float = d.g_opposite_position(d.g_from_direction)
  d.g_show_grid_backgrounds = false
  d.g_global_fixed_height = d.g_gutter_width * 3

  d._ ['body'] {
    d.font_family '"Helvetica Neue"', 'Helvetica', 'Arial', 'sans_serif'
    d.line_height 1.5
  }

  d._ ['footer'] {
    d.full
    d.pad(3,3)
  }

  d._ ['input[type=search]'] {
    d.font_size 16.px
  }

  d._ ['.susy_container:after'] {
    d.container
    # d.susy_grid_background
  }

  d._ ['.list_layout'] {
    d.columns(3)
    d.alpha

    d._ ['.list_style'] {
      d._ ['input'] {
        d.width 100.percent
        d.margin_bottom 0.5.em
      }

      d.padding 1.em
      d.background 0xF5F5F5.color

      r = 8
      d.border 'solid', 1, '#eee', r, r, r, r

      d.drop_shadow 1, 1, 1, '#fafafa', true
    }
  }

  d._ ['.detail_view'] {
    d.columns(9)
    d.omega
  }

  d._ ['#global_nav'] {
    # font_size: 1.5em
    # line_height: 3em

    d.background_color '#333'
    d.color '#eee'
    d.position 'fixed'
    d.top 0
    d.right 0
    d.left 0
    d.min_height d.g_global_fixed_height
    d.background '-webkit-gradient(linear, 0% 100%, 0% 0%, from(#222), to(#333))'
    d.drop_shadow 0, 5, 5
  }

  d._ ['#global_page'] {
    d.width '100%'
    d.padding_top(d.g_global_fixed_height + 0.5)
    d.margin_top d.g_gutter_width
  }

  puts RubyCss.to_css_simple d.raw
end

# file
# local
local2
