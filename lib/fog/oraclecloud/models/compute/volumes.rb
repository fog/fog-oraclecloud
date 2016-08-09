module Fog
  module Compute
  	class Oracle
	    class Volumes < Fog::Collection

	    	model Fog::Compute::Oracle::Volume
				
				def all
					data = service.list_volumes().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_volume(name).body
          new(data)
        end
	    end
	  end
  end
end
