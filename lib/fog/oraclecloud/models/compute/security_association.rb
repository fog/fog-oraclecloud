require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityAssociation < Fog::Model
	      identity  :name

	      attribute :seclist
	      attribute :vcable
	      attribute :uri

 				def save
          #identity ? update : create
          create
        end

				def create
        	requires :name, :seclist, :vcable
          
          data = service.create_security_association(name, seclist, vcable)
        end

        def destroy
          requires :name
          service.delete_security_association(name)
        end
	    end
	  end
  end
end
