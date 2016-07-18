module Fog
  module Compute
    class Oracle
      class Real
      	def list_image_lists
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end
    end
  end
end
