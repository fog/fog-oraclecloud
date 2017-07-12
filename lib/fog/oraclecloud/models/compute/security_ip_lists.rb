require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityIpLists < Fog::Collection

	    	model Fog::Compute::OracleCloud::SecurityIpList
				
				def all
					data = service.list_security_ip_lists().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_security_ip_list(name).body
          new(data)
        end
	    end
	  end
  end
end
