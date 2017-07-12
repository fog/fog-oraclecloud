require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class IpAssociations < Fog::Collection

	    	model Fog::Compute::OracleCloud::IpAssociation
				
				def all
					data = service.list_ip_associations().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_ip_association(name).body
          new(data)
        end
	    end
	  end
  end
end
