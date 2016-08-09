module Fog
  module Storage
    class Oracle
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
    end
  end
end
