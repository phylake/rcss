module Rcss
  module Helpers
    def max(a,b)
      a > b ? a : b
    end

    def warn(msg)
      puts "/* WARNING: #{msg.gsub(/\*+\\+/,'')} */"
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

    def unquote(value)
      value.gsub(/^('|")+/,'').gsub(/('|")+$/,'')
    end
  end

  Dsl.send(:include, Helpers)
end
