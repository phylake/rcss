module RubyCss
  module Helpers
    def ceil(a,b)
      a > b ? a : b
    end

    def warn(msg)
      puts "WARNING: #{msg}"
    end

    def opposite_position(p)
      case p
      when 'top'; 'bottom'
      when 'bottom'; 'top'
      when 'left'; 'right'
      when 'right'; 'left'
      when 'center'; 'center'
      end
    end
  end

  Dsl.send(:include, Helpers)
end
