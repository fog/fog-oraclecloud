module Fog
  module Compute
    class OracleCloud
      class Real
				def get_ip_reservation(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/ip/reservation/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_ip_reservation(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          if ip = self.data[:ip_reservations][clean_name] 
            response.status = 200
            response.body = ip
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("IP Reservation #{name} does not exist");
          end
        end
      end
    end
  end
end
