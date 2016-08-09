module Fog
  module Compute
    class Oracle
      class Real
      	def create_ssh_key (name, enabled, key)
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
              'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
              'enabled'					    => enabled,
              'key'					        => key
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/sshkey/",
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
