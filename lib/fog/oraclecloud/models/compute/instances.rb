require 'fog/core/collection'
require 'fog/oracle/models/compute/image'

module Fog
  module Compute
  	class Oracle
	    class Instances < Fog::Collection

	    	model Fog::Compute::Oracle::Instance
				
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
