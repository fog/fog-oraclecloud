module Fog
  module Compute
    class OracleCloud
      class Real
      	def delete_instance (name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end         
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/instance#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def delete_instance(name)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          self.data[:instances][name]['state'] = 'stopping'
          response.status = 204
          response
        end
      end
    end
  end
end
