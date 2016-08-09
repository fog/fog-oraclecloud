module Fog
  module Compute
    class Oracle
      class Real
      	def list_volumes
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/storage/volume/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end
    end
  end
end
