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

      class Mock
        def update_ssh_key (name, enabled, key)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          if sshkey = self.data[:sshkeys][clean_name] 
            self.data[:sshkeys][clean_name].merge!({
              'name' => "/Compute-#{@identity_domain}/#{@username}/#{clean_name}",
              'enabled' => enabled,
              'key' => key,
              'uri' => "#{@api_endpoint}sshkey/#{clean_name}"              
            })
            response.status = 200
            response.body = self.data[:sshkeys][clean_name]
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("SSHKey #{name} does not exist");
          end
        end
      end
    end
  end
end
