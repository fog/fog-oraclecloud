module Fog
  module Compute
    class OracleCloud
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

      class Mock
        def list_image_lists
          response = Excon::Response.new

          images = self.data[:image_lists].values

          response.body = {
            'result' => images
          }
          response
        end
      end
    end
  end
end
