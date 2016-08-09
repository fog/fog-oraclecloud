module Fog
  module Compute
  	class Oracle
	    class Orchestrations < Fog::Collection

	    	model Fog::Compute::Oracle::Orchestration
				
 				def get(name)
          data = service.get_orchestration(name).body
          new(data)
        end

				def all
					data = service.list_orchestrations().body['result']
					load(data)
				end
	    end
	  end
  end
end
