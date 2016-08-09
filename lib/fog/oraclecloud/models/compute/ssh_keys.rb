require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class SshKeys < Fog::Collection

	    	model Fog::Compute::OracleCloud::SshKey
				
 				def get(name)
          data = service.get_ssh_key(name).body
          new(data)
        end

				def all
					data = service.list_ssh_keys().body['result']
					load(data)
				end
	    end
	  end
  end
end
