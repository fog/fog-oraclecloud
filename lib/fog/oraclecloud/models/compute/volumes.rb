module Fog
  module Compute
  	class OracleCloud
	    class Volumes < Fog::Collection

	    	model Fog::Compute::OracleCloud::Volume
				
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
