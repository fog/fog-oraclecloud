require 'fog/core/collection'
require 'fog/oracle/models/compute/security_rule'

module Fog
  module Compute
  	class Oracle
	    class SecurityRules < Fog::Collection

	    	model Fog::Compute::Oracle::SecurityRule
				
				def all
					data = service.list_security_rules().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_security_rule(name).body
          new(data)
        end
	    end
	  end
  end
end
