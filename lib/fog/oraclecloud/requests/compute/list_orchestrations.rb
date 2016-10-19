module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_orchestrations
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/orchestration/Compute-#{@identity_domain}/"
          )
          response
        end
      end

      class Mock
        def list_orchestrations
          response = Excon::Response.new

          orchs = self.data[:orchestrations].values
          response.body = {
            'result' => orchs
          }
          response
        end
      end
    end
  end
end
