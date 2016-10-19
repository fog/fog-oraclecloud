module Fog
  module Storage
    class OracleCloud
      class Real
      	def list_containers
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/v1/Storage-#{@identity_domain}?format=json"
          )
          response
        end
      end

      class Mock
        def list_containers
          response = Excon::Response.new

          containers = self.data[:containers].values

          response.body = containers
          response
        end
      end
    end
  end
end
