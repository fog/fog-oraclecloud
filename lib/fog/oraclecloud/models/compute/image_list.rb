require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class ImageList < Fog::Model
	      identity  :name

	      attribute :uri
	      attribute :default
	      attribute :description
	      attribute :entries

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :name, :description
          
          data = service.create_image_list(name, description,
                                            :default => default)
        end

        def update
        	requires :name

        	data = service.update_image_list(name, :description=>description, :default=>default)
        end

        def delete
        	requires :name
        	service.delete_image_list(name)
        end
	    end
	  end
  end
end
