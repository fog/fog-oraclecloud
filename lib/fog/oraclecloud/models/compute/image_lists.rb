require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class ImageLists < Fog::Collection

	    	model Fog::Compute::OracleCloud::ImageList
				
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
