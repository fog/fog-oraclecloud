require 'fog/core/model'

module Fog
  module Compute
  	class Oracle
	    class Image < Fog::Model
	      identity  :name

	      attribute :uri
	      attribute :default
	      attribute :description
	      attribute :entries

	      # Only used in create
	      attribute :default

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :name, :description
          
          data = service.create_image(name, description,
                                            :default => default)
        end

        def update
        	requires :name

        	data = service.update_image(name, :description=>description, :default=>default)
        end

        def delete
        	requires :name
        	service.delete_image(name)
        end
	    end
	  end
  end
end
