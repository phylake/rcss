# reset
require 'rcss/mixins/compass/reset/utilities'

# utilities
require 'rcss/mixins/compass/utilities/general/clearfix'
require 'rcss/mixins/compass/utilities/general/float'

module Rcss
  Dsl.send(:include, Compass)
end
