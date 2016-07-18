module Fog
  module Compute
    class Oracle
      class Real
      	def delete_image (name)
          request(
            :method   => 'DELETE',
            :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
