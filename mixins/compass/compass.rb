# reset
require './mixins/compass/reset/utilities'

# utilities
require './mixins/compass/utilities/general/clearfix'
require './mixins/compass/utilities/general/float'

module RubyCss
  Dsl.send(:include, Compass)
end
