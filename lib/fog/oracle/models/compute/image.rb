require 'fog/core/model'

module Fog
  module Compute
  	class Oracle
	    class Image < Fog::Model
	      identity  :name

	      attribute :version
	      attribute :attributes
	      attribute :machineimages

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :name, :description
          
          data = service.create_image(name, version, attributes, machineimages)
        end

        def delete
        	requires :name
        	service.delete_image(name, version)
        end
	    end
	  end
  end
end
