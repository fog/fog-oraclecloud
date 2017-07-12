module Fog
  module Compute
  	class OracleCloud
	    class SecurityApplications < Fog::Collection

	    	model Fog::Compute::OracleCloud::SecurityApplication
				
				def all
					data = service.list_security_applications().body['result']
					public_data = service.list_security_applications('public').body['result']
					load(data.concat(public_data))
				end

				def all_public
					data = service.list_security_applications('public').body['result']
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
