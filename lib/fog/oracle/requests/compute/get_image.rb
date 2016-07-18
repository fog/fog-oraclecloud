module Fog
  module Compute
    class Oracle
      class Real
				def get_iamge(name)
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
