# reset
require 'ruby_css/mixins/compass/reset/utilities'

# utilities
require 'ruby_css/mixins/compass/utilities/general/clearfix'
require 'ruby_css/mixins/compass/utilities/general/float'

module RubyCss
  Dsl.send(:include, Compass)
end
