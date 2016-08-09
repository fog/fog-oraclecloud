module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_instance (name, shape, imagelist, label, sshkeys)
          # This will create an instance using a Launchplan. Consider using an orchestration plan for more control
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
            'instances'    => [{
              'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
              'shape'					      => shape,
              'imagelist'					  => imagelist,
              'label'               => label,
              'sshkeys'             => sshkeys
            }]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/launchplan/",
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
