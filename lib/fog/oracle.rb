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

    autoload :Java, File.expand_path('../oracle/java', __FILE__)
    autoload :Database, File.expand_path('../oracle/database', __FILE__)
    autoload :SOA, File.expand_path('../oracle/soa', __FILE__)

  	service(:compute, 'Compute')
  	service(:storage, 'Storage')
    service(:java, 'Java')
    service(:database, 'Database')
    service(:soa, 'SOA')
  end
end
