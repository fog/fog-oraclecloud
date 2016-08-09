require 'fog/core'
require 'fog/json'
require 'fog/xml'

require File.expand_path('../oraclecloud/version', __FILE__)

module Fog
  module Compute
  	autoload :OracleCloud, File.expand_path('../oraclecloud/compute', __FILE__)
  end

  module Storage
  	autoload :OracleCloud, File.expand_path('../oraclecloud/storage', __FILE__)
  end

  module OracleCloud
  	extend Fog::Provider

    autoload :Java, File.expand_path('../oraclecloud/java', __FILE__)
    autoload :Database, File.expand_path('../oraclecloud/database', __FILE__)
    autoload :SOA, File.expand_path('../oraclecloud/soa', __FILE__)

  	service(:compute, 'Compute')
  	service(:storage, 'Storage')
    service(:java, 'Java')
    service(:database, 'Database')
    service(:soa, 'SOA')
  end
end
