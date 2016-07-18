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

 				def save
          #identity ? update : create
          create
        end
	    end
	  end
  end
end
