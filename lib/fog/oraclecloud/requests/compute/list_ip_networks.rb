module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_ip_networks
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/network/v1/ipnetwork/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end

      class Mock
        def list_ip_networks
          response = Excon::Response.new

          ips = self.data[:ip_networks].values
          response.body = {
            'result' => ips
          }
          response
        end
      end
    end
  end
end
