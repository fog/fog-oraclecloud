require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class IpReservations < Fog::Collection

	    	model Fog::Compute::OracleCloud::IpReservation
				
				def all
					data = service.list_ip_reservations().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_ip_reservation(name).body
          new(data)
        end
	    end
	  end
  end
end
