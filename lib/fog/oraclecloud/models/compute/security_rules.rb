require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityRules < Fog::Collection

	    	model Fog::Compute::OracleCloud::SecurityRule
				
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
