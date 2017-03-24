module Fog
  module Compute
    class OracleCloud
      class Real
      	def delete_ip_network (name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/network/v1/ipnetwork/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def delete_ip_network(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          self.data[:ip_networks].delete(clean_name)
          response.status = 204
          response
        end
      end
    end
  end
end
