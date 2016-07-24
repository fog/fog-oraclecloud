require 'fog/core/collection'
require 'fog/oracle/models/compute/image'

module Fog
  module Compute
  	class Oracle
	    class SshKeys < Fog::Collection

	    	model Fog::Compute::Oracle::SshKey
				
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
