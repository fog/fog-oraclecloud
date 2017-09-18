require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class Shapes < Fog::Collection

	    	model Fog::Compute::OracleCloud::Shape
				
 			def get(name)
                data = service.get_shape(name).body
                new(data)
            end

			def all
				data = service.list_shapes().body['result']
				load(data)
			end
	    end
	  end
  end
end
