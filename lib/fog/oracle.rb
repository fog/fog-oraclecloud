require 'fog/core'
require 'fog/json'
require 'fog/xml'

require File.expand_path('../oracle/version', __FILE__)

module Fog
  module Compute
  	autoload :Oracle, File.expand_path('../oracle/compute', __FILE__)
  end

  module Storage
  	autoload :Oracle, File.expand_path('../oracle/storage', __FILE__)
  end

  module Oracle
  	extend Fog::Provider

  	service(:compute, 'Compute')
  	service(:storage, 'Storage')
  end
end
