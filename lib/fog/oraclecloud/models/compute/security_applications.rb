require 'fog/core/collection'
require 'fog/oracle/models/compute/security_application'

module Fog
  module Compute
  	class Oracle
	    class SecurityApplications < Fog::Collection

	    	model Fog::Compute::Oracle::SecurityApplication
				
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
