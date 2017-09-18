require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class Images < Fog::Collection

    	model Fog::Compute::OracleCloud::Image

		def get(name)
            data = service.get_image(name).body
            new(data)
        end

		def all
			data = service.list_images().body['result']
			load(data)
		end
        def all_public
            data = service.list_public_images().body['result']
            load(data)
        end
	    end
	  end
  end
end
