require 'fog/core/collection'
require 'fog/oracle/models/compute/image'

module Fog
  module Compute
  	class Oracle
	    class Images < Fog::Collection

	    	model Fog::Compute::Oracle::Image
				
 				def get(name, version)
          data = service.get_image(name, version).body
          new(data)
        end

	    end
	  end
  end
end
