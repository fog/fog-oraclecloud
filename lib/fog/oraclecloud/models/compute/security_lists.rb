require 'fog/core/collection'
require 'fog/oracle/models/compute/security_list'

module Fog
  module Compute
  	class Oracle
	    class SecurityLists < Fog::Collection

	    	model Fog::Compute::Oracle::SecurityList
				
				def all
					data = service.list_security_lists().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_security_list(name).body
          new(data)
        end
	    end
	  end
  end
end
