require 'fog/core/model'

module Fog
  module Compute
  	class Oracle
	    class Image < Fog::Model
	      identity  :name

	      attribute :name
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
	    end
	  end
  end
end
