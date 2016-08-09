module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_image (account, name, no_upload, file, sizes)
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
            'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'account'					    => account,
            'no_upload'					  => no_upload,
            'file'                => file,
            'sizes'               => sizes
          }
          body_data = body_data.reject {|key, value| value.nil?}

          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/#{name}",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
