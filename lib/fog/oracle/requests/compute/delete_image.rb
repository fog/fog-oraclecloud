module Fog
  module Compute
    class Oracle
      class Real
      	def delete_image (name, version)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/#{name}/entry/#{version}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
