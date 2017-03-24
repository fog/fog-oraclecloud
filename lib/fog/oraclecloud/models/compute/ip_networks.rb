require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class IpNetworks < Fog::Collection

	    	model Fog::Compute::OracleCloud::IpNetwork
				
				def all
					data = service.list_ip_networks().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_ip_network(name).body
          new(data)
        end
	    end
	  end
  end
end
