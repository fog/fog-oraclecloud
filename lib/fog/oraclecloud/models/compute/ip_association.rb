require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class IpAssociation < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :ip
	      attribute :parentpool
	      attribute :reservation
	      attribute :vcable
	      attribute :uri

 				def save
 					if name.nil? then
	          create
	         else
            # TODO: Support?
	         	#update
	        end
        end

        def create 
          requires :parentpool, :vcable
          data = service.create_ip_association({
          	:parentpool => parentpool,
            :vcable => vcable
          })
          merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_ip_association(name)
        end

	    end
	  end
  end
end
