module Fog
  module Compute
    class OracleCloud
      class Real
      	def update_image (name, options={})
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
            'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'description'					=> options[:description],
            'default'					   	=> options[:default]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'PUT',
            :expects  => 200,
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
