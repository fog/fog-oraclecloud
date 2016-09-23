module Fog
  module Compute
    class OracleCloud
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

      class Mock
        def create_ssh_key (name, enabled, key)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          data = {
            'name' => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'enabled' => enabled,
            'key' => key,
            'uri' => "#{@api_endpoint}sshkey/#{name}"
          }
          self.data[:sshkeys][name] = data

          response.status = 201
          response.body = self.data[:sshkeys][name]
          response
        end
      end
    end
  end
end
