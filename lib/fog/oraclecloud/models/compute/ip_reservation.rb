require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class IpReservation < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :ip
	      attribute :parentpool
	      attribute :permanent
	      attribute :quota
	      attribute :tags
	      attribute :uri
	      attribute :used

 				def save
 					if !name.nil? && !name.start_with?("/Compute-") then
	          create
	         else
	         	update
	        end
        end

        def create 
          data = service.create_ip_reservation({
          	:name => name,
          	:parentpool => parentpool || '/oracle/public/ippool', 
          	:permanent => permanent || true,
          	:tags => tags
          })
          merge_attributes(data.body)
        end

        def update
        	data = service.update_ip_reservation({
        		:name => name,
        		:parentpool => parentpool,
        		:permanent => permanent,
        		:tags => tags
        	})
        	merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_ip_reservation(name)
        end

	    end
	  end
  end
end
