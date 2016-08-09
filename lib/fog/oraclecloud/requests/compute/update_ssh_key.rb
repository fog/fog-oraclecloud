module Fog
  module Compute
    class OracleCloud
      class Real
      	def update_ssh_key (name, enabled, key)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end   
          body_data     = {
            'name'             		=> name,
            'enabled'					    => enabled,
            'key'					        => key
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/sshkey#{name}",
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
