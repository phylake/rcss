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
      raise "need a block" unless blk.is_a?(Proc)
      as = *as
      as = as.map {|a| a.to_s}

      h = @stack.last || {}
      @stack << h[@last_as = as] = {}

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
        
        return @gs[:"#{meth}="]
      end

      k    = meth.to_s.gsub(/_/, '-')
      v    = args.join(' ')
      h    = {}
      h[k] = v
      mixin h
    end

    def mixin(value)
      # puts "mixing %p" % value
      
      clean = {}
      value.each do |k,v|
        k = k.to_s.gsub(/_/, '-')
        if @stack.last.key?(k)
          begin
            raise
          rescue Exception => e
            # warn "overwriting #{k}\n\t#{e.backtrace.join("\n\t")}"
          end
        end
        clean[k] = v
      end

      @stack.last.merge!(clean)
      clean
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
        subs << "\n   #{k.to_s}: #{v.to_s};" unless v.to_s == ''
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

def susy_local
  d = RubyCss::Dsl.new

  d.g_total_cols = 12
  d.g_col_width = 4.em
  d.g_gutter_width = 1.em
  d.g_side_gutter_width = d.g_gutter_width
  d.g_from_direction = 'left'
  d.g_omega_float = d.opposite_position(d.g_from_direction)

  yield d
  
  puts RubyCss.to_css_simple d.raw
  # puts d.raw
end



# file 'examples/sample.rb'



# susy_local do |d|
#   d._ ['.footer'] {
#     d.full
#     d.pad(3,3)
#   }
# end
  # footer {
  #   clear: both;
  #   margin-left: 1.639%;
  #   margin-right: 1.639%;
  #   padding-left: 24.59%;
  #   padding-right: 24.59%;
  # }

# susy_local do |d|
#   d._ ['.susy_container'] {
#     d.container
#   }

#   d._ ['.susy_container:after'] {
#     d.pie_clearfix
#   }
# end
  # .susy_container {
  #   *zoom: 1;
  #   margin: auto;
  #   width: 61em;
  #   max-width: 100%;
  # }
  # .susy_container:after {
  #   content: "";
  #   display: table;
  #   clear: both;
  # }

susy_local do |d|
  d._ ['.detail_view'] {
    d.columns(9)
    d.omega
  }
end
  # .detail_view {
  #   display: inline;
  #   float: left;
  #   width: 72.131%;
  #   margin-right: 1.639%;
  #   display: inline;
  #   float: right;
  #   margin-right: 1.639%;
  #   #margin-left: -1em;
  # }



















