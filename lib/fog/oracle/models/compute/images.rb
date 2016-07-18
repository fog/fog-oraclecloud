require 'fog/core/collection'
require 'fog/oracle/models/compute/image'

module Fog
  module Compute
  	class Oracle
	    class Images < Fog::Collection

	    	model Fog::Compute::Oracle::Image
				
				def all
					data = service.list_images().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_image(name).body
          new(data)
        end
	    end
	  end
  end
end
