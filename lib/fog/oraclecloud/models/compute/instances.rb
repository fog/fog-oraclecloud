require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class Instances < Fog::Collection

	    	model Fog::Compute::OracleCloud::Instance
				
 				def get(name)
          data = service.get_instance(name).body
          new(data)
        end

				def all
					data = service.list_instances().body['result']
					load(data)
				end
	    end
	  end
  end
end
