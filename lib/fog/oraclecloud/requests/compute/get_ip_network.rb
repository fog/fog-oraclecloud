module Fog
  module Compute
    class OracleCloud
      class Real
				def get_ip_reservation(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/network/v1/ipnetwork/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_ip_network(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''

          if ip = self.data[:ip_networks][clean_name] 
            response.status = 200
            response.body = ip
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("IP Network #{name} does not exist");
          end
        end
      end
    end
  end
end
