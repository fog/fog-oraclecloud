module Fog
  module Compute
    class Oracle
      class Real
      	def list_images
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/machineimage/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end
    end
  end
end
