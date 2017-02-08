module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_ip_reservations
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/ip/reservation/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end

      class Mock
        def list_ip_reservations
          response = Excon::Response.new

          ips = self.data[:ip_reservations].values
          response.body = {
            'result' => ips
          }
          response
        end
      end
    end
  end
end
