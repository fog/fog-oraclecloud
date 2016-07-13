require 'fog/core'
require 'fog/json'

require File.expand_path('../oracle/version', __FILE__)

module Fog
  module Compute
  	autoload :Oracle, File.expand_path('../oracle/compute', __FILE__)
  end

  module Oracle
  	extend Fog::Provider

  	service(:compute, 'Compute')
  end
end
