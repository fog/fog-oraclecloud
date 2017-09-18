module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_shapes
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/shape/",
            :headers => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def list_shapes
          response = Excon::Response.new

          shapes = self.data[:shapes].values

          response.body = {
            'result' => shapes
          }
          response
        end
      end
    end
  end
end
