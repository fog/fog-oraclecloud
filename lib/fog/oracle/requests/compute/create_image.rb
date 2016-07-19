module Fog
  module Compute
    class Oracle
      class Real
      	def create_image (name, version, attributes, machineimages)
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
            'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'version'					    => version,
            'attributes'					=> attributes,
            'machineimages'       => machineimages
          }
          body_data = body_data.reject {|key, value| value.nil?}

          pp Fog::JSON.encode(body_data)
          #request(
          #  :method   => 'POST',
          #  :expects  => 201,
          #  :path     => "/imagelist/Compute-#{@identity_domain}/#{@username}/#{name}",
          #  :body     => Fog::JSON.encode(body_data),
          #  :headers  => {
          #    'Content-Type' => 'application/oracle-compute-v3+json'
          #  }
          #)
      	end
      end
    end
  end
end
