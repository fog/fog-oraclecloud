module Fog
  module Compute
    class OracleCloud
      class Real
				def get_image_list(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/#{name}",
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
