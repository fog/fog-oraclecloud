module Fog
  module Compute
    class OracleCloud
      class Real
				def get_image(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/machineimage/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
        def get_image_public(name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/machineimage#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end
    end
  end
end
