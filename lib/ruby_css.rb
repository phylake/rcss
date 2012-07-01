require 'ruby_css/version'
require 'ruby_css/global'

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

  require 'ruby_css/mixins/all'
end# RubyCss
