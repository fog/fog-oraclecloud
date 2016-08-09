require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityLists < Fog::Collection

	    	model Fog::Compute::OracleCloud::SecurityList
				
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
