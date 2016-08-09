require 'fog/core/collection'
require 'fog/oracle/models/compute/image'

module Fog
  module Compute
  	class Oracle
	    class ImageLists < Fog::Collection

	    	model Fog::Compute::Oracle::ImageList
				
				def all
					data = service.list_image_lists().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_image_list(name).body
          new(data)
        end
	    end
	  end
  end
end
