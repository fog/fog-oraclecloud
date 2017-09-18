module Fog
  module Compute
    class OracleCloud
      class Real
        def list_images
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/machineimage/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
        def list_public_images
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/machineimage/oracle/public/"
          )
          response
        end
      end
    end
  end
end
