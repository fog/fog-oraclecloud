module Fog
  module Compute
    class OracleCloud
      class Real
      	def delete_security_list(name)
      		# Just in case it's already set
      		name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
	      	request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/seclist/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
      class Mock
        def delete_security_list(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          self.data[:security_lists].delete(clean_name)
          response.status = 204
          response
        end
      end
    end
  end
end
