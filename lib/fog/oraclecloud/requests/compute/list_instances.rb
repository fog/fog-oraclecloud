module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_instances
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/instance/Compute-#{@identity_domain}/"
          )
          response
        end
      end
      class Mock
        def list_instances
          response = Excon::Response.new

          instances = self.data[:instances].values

          response.body = {
            'result' => instances
          }
          response
        end
      end
    end
  end
end
