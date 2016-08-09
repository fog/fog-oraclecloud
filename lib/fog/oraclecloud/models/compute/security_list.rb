require 'fog/core/model'

module Fog
  module Compute
  	class Oracle
	    class SecurityList < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :name
	      attribute :uri
	      attribute :outbound_cidr_policy
	      attribute :proxyuri
	      attribute :policy

	      # Only used in create
	      attribute :description

 				def save
          #identity ? update : create
          create
        end
	    end
	  end
  end
end
