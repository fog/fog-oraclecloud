require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityApplications < Fog::Collection

	    	model Fog::Compute::OracleCloud::SecurityApplication
				
				def all
					data = service.list_security_applications().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_security_application(name).body
          new(data)
        end
	    end
	  end
  end
end
